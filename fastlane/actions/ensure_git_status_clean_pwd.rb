module Fastlane
  module Actions
    module SharedValues
      ENSURE_GIT_STATUS_CLEAN_PWD_CUSTOM_VALUE = :ENSURE_GIT_STATUS_CLEAN_PWD_CUSTOM_VALUE
    end

    class EnsureGitStatusCleanPwdAction < Action
      def self.run(params)
        path                     = params[:path]
        show_uncommitted_changes = params[:show_uncommitted_changes]
        show_diff                = params[:show_diff]

        repo_status = Actions.sh("cd #{path}; git status --porcelain")
        repo_clean  = repo_status.empty?

        if repo_clean
          UI.success('✅[ensure_git_status_clean_pwd] Git status is clean, all good!')
          true
        else
          error_message = '❌[ensure_git_status_clean_pwd] Git repository is dirty! Please ensure the repo is in a clean state by committing/stashing/discarding all changes first.'
          error_message += "\nUncommitted changes:\n#{repo_status}" if show_uncommitted_changes
          if show_diff
            repo_diff = Actions.sh("cd #{path}; git diff")
            error_message += "\nGit diff: \n#{repo_diff}"
          end
          UI.user_error!(error_message)
        end
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
            key: :show_uncommitted_changes,
            env_name: "FL_ENSURE_GIT_STATUS_CLEAN_SHOW_UNCOMMITTED_CHANGES",
            description: "The flag whether to show uncommitted changes if the repo is dirty",
            optional: true,
            default_value: false,
            is_string: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :show_diff,
            env_name: "FL_ENSURE_GIT_STATUS_CLEAN_SHOW_DIFF",
            description: "The flag whether to show the git diff if the repo is dirty",
            optional: true,
            default_value: false,
            is_string: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :path,
            description: "/path/to/.git"
          )
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['ENSURE_GIT_STATUS_CLEAN_PWD_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Your GitHub/Twitter Name"]
      end

      def self.is_supported?(platform)
        # you can do things like
        #
        #  true
        #
        #  platform == :ios
        #
        #  [:ios, :mac].include?(platform)
        #

        platform == :ios
      end
    end
  end
end
