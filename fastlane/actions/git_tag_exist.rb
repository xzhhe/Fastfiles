module Fastlane
  module Actions
    module SharedValues
      GIT_TAG_EXIST_CUSTOM_VALUE = :GIT_TAG_EXIST_CUSTOM_VALUE
    end

    class GitTagExistAction < Action
      def self.run(params)
        repo        = params[:repo]
        tag         = params[:tag]
        remote      = params[:remote]
        remote_name = params[:remote_name]

        tag_ref = "refs/tags/#{tag.shellescape}"
        if remote
          command = "cd #{repo}; git ls-remote -q --exit-code #{remote_name.shellescape} #{tag_ref}"
        else
          command = "cd #{repo}; git rev-parse -q --verify #{tag_ref}"
        end

        exists = true
        Actions.sh(
          command,
          log: FastlaneCore::Globals.verbose?,
          error_callback: ->(result) { exists = false }
        )
        exists
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
            key: :remote,
            description: "Whether to check remote. Defaults to `false`",
            type: Boolean,
            default_value: false,
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :remote_name,
            description: "The remote to check. Defaults to `origin`",
            default_value: 'origin',
            optional: true
          )
        ]
      end

      def self.output
        [
          ['GIT_TAG_EXIST_CUSTOM_VALUE', 'A description of what this value contains']
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
