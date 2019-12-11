module Fastlane
  module Actions
    module SharedValues
      GIT_COMMIT_PUSH_CUSTOM_VALUE = :GIT_COMMIT_PUSH_CUSTOM_VALUE
    end

    class GitCommitPushAction < Action
      def self.run(params)
        repo           = params[:repo]
        commit_message = params[:commit_message]
        branch         = params[:branch]

        Actions.sh("cd #{repo}; git commit -Am \"#{commit_message}\"; git push origin #{branch}")
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
            key: :commit_message,
            description: "commit message",
            verify_block: proc do |value|
              UI.user_error!("No commit given") unless (value and not value.empty?)
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :branch,
            description: "branch",
            verify_block: proc do |value|
              UI.user_error!("No branch given") unless (value and not value.empty?)
            end
          )
        ]
      end

      def self.output
        [
          ['GIT_COMMIT_PUSH_CUSTOM_VALUE', 'A description of what this value contains']
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
