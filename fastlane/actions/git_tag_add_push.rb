module Fastlane
  module Actions
    module SharedValues
      GIT_TAG_ADD_PUSH_CUSTOM_VALUE = :GIT_TAG_ADD_PUSH_CUSTOM_VALUE
    end

    class GitTagAddPushAction < Action
      def self.run(params)
        # add_tag(params)
        push_tag(params)
      end

      def self.add_tag(params)
        repo           = params[:repo]
        tag            = params[:tag]
        branch         = params[:branch]
        commit         = params[:commit]
        commit_message = params[:commit_message]

        tag = tag_name(params)
        UI.user_error!("❌  tag get failed") unless tag

        # "git tag -a <tag_name> <commit> -m \"<tag 描述信息>\""; git push origin <tag_name>
        cmds = ["cd #{repo}"]
        add_tag = if commit
          "git tag -a \"#{tag}\" #{commit}"
        elsif branch
          "git tag -a \"#{tag}\" #{branch}"
        else
          "git tag -a #{tag}"
        end
        add_tag = "#{add_tag} -m \"#{commit_message}\"" if commit_message
        cmds << add_tag

        output = Actions.sh(cmds.join(';'))
        if output.include?('fatal')
          UI.user_error!("❌ #{output}")
        end

        UI.message("✅ git add tag #{tag} success")
      end

      def self.push_tag(params)
        repo           = params[:repo]
        tag            = params[:tag]
        force          = params[:force]

        cmds = [
          "cd #{repo}",
          "git push origin refs/tags/#{tag}"
        ]
        cmds << '--force' if force

        Actions.sh(cmds.join(' '))
        UI.success('✅ git push tag')
      end

      def self.tag_name(params)
        repo   = params[:repo]
        prefix = params[:prefix]
        tag    = params[:tag]

        if tag
          if prefix
            "#{prefix}#{tag}"
          else
            tag
          end
        else
          cmds = ["cd #{repo}", 'git fetch --tags']
          if prefix
            cmds << "git tag --list '#{prefix}*'"
          else
            cmds << 'git tag'
          end

          result = `#{cmds.join(';')}`
          return nil unless result

          tags = result.split("\n")
          return nil if tags.empty?

          if prefix
            "#{prefix}#{increate_tag(max_tag(tags, prefix))}"
          else
            increate_tag(max_tag(tags, prefix))
          end
        end
      end

      def self.increate_tag(tag)
        versions = tag.split(".").map(&:to_i)
        versions[versions.count - 1] = pp versions[versions.count - 1] + 1
        versions.join('.')
      end

      def self.description
        "A short description with <= 80 characters of what this action does"
      end

      def self.details
        "You can use this action to do cool things..."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :repo,
            description: "your git repo path",
            verify_block: proc do |value|
              UI.user_error!("No repo given") unless (value and not value.empty?)
              UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :tag,
            description: "tag",
            verify_block: proc do |value|
              UI.user_error!("No tag given") unless (value and not value.empty?)
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :prefix,
            description: "tag name prefix, like: master_1.2.3 , v1.0.0",
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :branch,
            description: "branch",
            optional: true,
            default_value: 'master'
          ),
          FastlaneCore::ConfigItem.new(
            key: :commit,
            description: "commit",
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :commit_message,
            description: "commit_message",
            verify_block: proc do |value|
              UI.user_error!("No tag given") unless (value and not value.empty?)
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :force,
            description: "Force push to remote",
            is_string: false,
            default_value: false,
            optional: true
          )
        ]
      end

      def self.output
        [
          ['GIT_TAG_ADD_PUSH_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        ["Your GitHub/Twitter Name"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
