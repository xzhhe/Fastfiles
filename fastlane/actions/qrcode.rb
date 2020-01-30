module Fastlane
  module Actions
    module SharedValues
      QRCODE_ACTION_QR_URL            = :QRCODE_ACTION_QR_URL
      QRCODE_ACTION_ITMS_SERVICES_URL = :QRCODE_ACTION_ITMS_SERVICES_URL
    end

    require 'erb'

    class QrcodeAction < Action
      def self.run(params)
        qrcode_api = params[:qrcode_api]
        plist      = params[:plist]
        size       = params[:size]

        v_itms_services_url = itms_services_url(plist, false)
        self.lane_context[SharedValues::QRCODE_ACTION_ITMS_SERVICES_URL] = v_itms_services_url

        v_coded_itms_services_url = url_encode(v_itms_services_url)
        qr_url = "#{qrcode_api}#{v_coded_itms_services_url}&size=#{size}"
        self.lane_context[SharedValues::QRCODE_ACTION_QR_URL] = qr_url

        qr_url
      end

      def self.url_encode(url)
        ERB::Util.url_encode(url)
      end

      def self.itms_services_url(plist_url, encode)
        if encode
          "itms-services://?action=download-manifest&url=#{url_encode(plist_url)}"
        else
          "itms-services://?action=download-manifest&url=#{plist_url}"
        end
      end

      def self.description
        "generate a url for qrcode url"
      end

      def self.details
        "You can use this action to do cool things..."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :qrcode_api,
            description: "generate qrcode server api",
            verify_block: proc do |value|
              UI.user_error!("No qrcode_api for QrcodeAction given") unless (value and not value.empty?)
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :plist,
            description: "plist url for itms-services",
            verify_block: proc do |value|
              UI.user_error!("No plist for QrcodeAction given") unless (value and not value.empty?)
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :size,
            description: "size for qrcode",
            optional: true,
            default_value: '120'
          )
        ]
      end

      def self.return_type
        :stirng
      end

      def self.output
        [
          ['QRCODE_ACTION_QR_URL', 'get result qrcode url']
        ]
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
