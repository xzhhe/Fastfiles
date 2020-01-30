module Fastlane
  module Actions
    module SharedValues
      DSYM_UUID_CUSTOM_VALUE = :DSYM_UUID_CUSTOM_VALUE
    end

    # pp dsym_uuid(dsym: '/Users/xiongzenghui/Desktop/release-502.dSYM/osee2unifiedRelease.app.dSYM')
    # pp dsym_uuid(dsyms: [
    #   '/Users/xiongzenghui/Desktop/release-502.dSYM/osee2unifiedRelease.app.dSYM',
    #   '/Users/xiongzenghui/Desktop/release-502.dSYM/Share.appex.dSYM',
    #   '/Users/xiongzenghui/Desktop/release-502.dSYM/notificationService.appex.dSYM',
    #   '/Users/xiongzenghui/Desktop/release-502.dSYM/todayWidget.appex.dSYM'
    # ])

    class DsymUuidAction < Action
      def self.run(params)
        dsym = params[:dsym]
        dsyms = params[:dsyms]

        if dsym
          dsym_to_hash(dsym)
        else
          dsym_to_array(dsyms)
        end
      end

      def self.dsym_to_array(dsyms)
        return nil unless dsyms

        dsyms.map { |d|
          dsym_to_hash(d)
        }
      end

      def self.dsym_to_hash(dsym)
        return nil unless dsym
        return nil unless File.exist?(dsym)

        ret = {}
        ret[:filepath] = dsym
        ret[:filename] = File.basename(dsym)
        ret[:uuid] = get_merge_dsym_uuid(dsym)
        ret[:origin_uuid] = get_origin_dsym_uuid(dsym)
        ret
      end

      def self.get_origin_dsym_uuid(dsym)
        dwarfdumps = get_dsym_uuid(dsym)
        return nil unless dwarfdumps

        dwarfdumps.split(" ")[1]
      end

      def self.get_merge_dsym_uuid(dsym)
        dwarfdumps = get_dsym_uuid(dsym)
        return nil unless dwarfdumps

        uuid = dwarfdumps.split(" ")[1]
        uuid.gsub('-', '')
      end

      def self.get_dsym_uuid(dsym)
        return nil unless dsym
        return nil unless File.exist?(dsym)

        # xcrun dwarfdump --uuid release_256_6.16.0_1555.dSYM/todayWidget.appex.dSYM
        `xcrun dwarfdump --uuid #{dsym}`
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
            key: :dsym,
            description: "dsym filepath",
            verify_block: proc do |value|
              UI.user_error!("No dsym filepath given") unless (value and not value.empty?)
              UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
            end,
            optional: true,
            conflicting_options: [:dsyms]
          ),
          FastlaneCore::ConfigItem.new(
            key: :dsyms,
            description: "dsym filepath",
            verify_block: proc do |value|
              UI.user_error!("No dsym filepath given") unless (value and not value.empty?)
            end,
            optional: true,
            is_string: false,
            type: Array,
            conflicting_options: [:dsym]
          )
        ]
      end

      def self.output
        [
          ['DSYM_UUID_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        ["xiongzenghui"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
