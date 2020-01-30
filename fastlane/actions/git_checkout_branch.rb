module Fastlane
  module Actions
    module SharedValues
      GIT_CHECKOUT_BRANCH_CUSTOM_VALUE = :GIT_CHECKOUT_BRANCH_CUSTOM_VALUE
    end

    class GitCheckoutBranchAction < Action
      def self.run(params)
        project = params[:project]
        branch = params[:branch]
        new_branch = params[:new_branch]

        cmds = if new_branch
                [
                  "cd #{project}",
                  "git checkout -b #{branch}"
                ]
              else
                [
                  "cd #{project}",
                  'git reset HEAD',
                  'git stash',
                  # "git checkout remotes/origin/#{branch}",
                  "git checkout #{branch}",
                  'git checkout . && git clean -df',
                  "git pull origin #{branch}"
                ]
              end

        Actions.sh(cmds.join(';'))
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
            key: :project,
            description: "git repo path"
          ),
          FastlaneCore::ConfigItem.new(
            key: :branch,
            description: "git exist branch"
          ),
          FastlaneCore::ConfigItem.new(
            key: :new_branch,
            description: "result.info",
            optional: true,
            is_string: false,
            default_value: false
          )
        ]
      end

      def self.output
        [
          ['GIT_CHECKOUT_BRANCH_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        ["xiongzenghui"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
