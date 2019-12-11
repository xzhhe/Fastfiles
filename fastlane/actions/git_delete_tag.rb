module Fastlane
  module Actions
    module SharedValues
      GIT_DELETE_TAG_CUSTOM_VALUE = :GIT_DELETE_TAG_CUSTOM_VALUE
    end

    class GitDeleteTagAction < Action
      def self.run(params)
        repo   = params[:repo]
        tag    = params[:tag]
        local  = params[:local]
        remote = params[:remote]

        local  ||= true
        remote ||= true

        cmds = [
          "cd #{repo}",
          ("git tag -d #{tag}" if local),
          ("git push origin :#{tag}" if remote)
        ].compact

        Actions.sh(cmds.join(';'))
        UI.message("✅ git delete tag #{tag} success")
        true
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
            key: :local,
            description: "did you remove <local> tag ???",
            optional: true,
            is_string: false,
            default_value: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :remote,
            description: "did you remove <remote> tag ???",
            optional: true,
            is_string: false,
            default_value: true
          )
        ]
      end

      def self.output
        [
          ['GIT_DELETE_TAG_CUSTOM_VALUE', 'A description of what this value contains']
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
