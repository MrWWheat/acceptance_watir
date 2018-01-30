require 'airborne'
require_relative '../api_test_config'

describe 'Network' do
  puts 'Network APIs'

  before(:all) {
    @config = APITestConfig.new
    @api_base_url = '/api/v1/OData'
    @network_id_get = @config.api_data['network_id_get']
    @headers = { :Authorization => "Bearer #{@config.access_token}",
                :Accept => "application/json",
                :content_type => "application/json",
                :verify_ssl => false }
  }

  it 'Get Network by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}').json", @headers
    expect_status(200)
    expect_json_keys('d.results', [:Id, :Domain, :Name])
  end

  it 'Get Network Aggregation by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/Aggregations.json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id, :Count, :Name])
  end

  it 'Get Network BusinessTemplates by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/BusinessTemplates.json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id, :Name, :Key, :Enabled])
  end

  it 'Get Network ButtonSizes by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/ButtonSizes.json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id, :Size, :Content, :Description])
  end

  it 'Get Network Configuration by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/Configuration.json", @headers
    expect_status(200)
    expect_json_keys('d.results', [:Id, :ModerationType, :BrandingMetadata, :ModerationThreshold])
  end

  it 'Get Network Conversations by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/Conversations.json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id, :Title, :OriginalContent, :TypeTrait, :RootPostId])
  end

  it 'Get Network CurrentEmailTemplate by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/CurrentEmailTemplate.json", @headers
    expect_status(200)
    expect_json_keys('d.results', [:Id,
                                  :HtmlContentHeader,
                                  :HtmlContentFooter,
                                  :PlainTextContentHeader,
                                  :PlainTextContentFooter,
                                  :HtmlFooter,
                                  :PlainTextFooter])
  end

  it 'Get Network DefaultAdminGroup by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/DefaultAdminGroup.json", @headers
    expect_status(200)
    expect_json_keys('d.results', [:Id, :Name, :Description])
  end

  it 'Get Network DefaultBloggerGroup by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/DefaultBloggerGroup.json", @headers
    expect_status(200)
    expect_json_keys('d.results', [:Id, :Name, :Description])
  end

  it 'Get Network DefaultModeratorGroup by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/DefaultModeratorGroup.json", @headers
    expect_status(200)
    expect_json_keys('d.results', [:Id, :Name, :Description])
  end

  # it 'Get Network EcfConfig by Network ID' do
  #   get "#{@api_base_url}/Networks('#{@network_id_get}')/EcfConfig.json", @headers
  #   expect_status(200)
  #   expect_json_keys('d.results', [:CctrUrl, :QueueAddress, :SapUi5Url])
  # end

  it 'Get Network EnabledBusinessTemplate by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/EnabledBusinessTemplate.json", @headers
    expect_status(200)
    expect_json_keys('d.results', [:Name, :Key, :Enabled])
  end

  it 'Get Network FontSizes by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/FontSizes.json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id, :Size, :NetworkId, :CreatedAt, :UpdatedAt])
  end

  it 'Get Network Fonts by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/Fonts.json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id, :Name, :NetworkId, :CreatedAt, :UpdatedAt])
  end

  it 'Get Network HomeLayout by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/HomeLayout.json", @headers
    expect_status(200)
    expect_json_keys('d.results', [:Id, :CreatorId, :PageName, :LayoutName, :Config])
  end

  it 'Get Network idp configuration by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/IdpConfigurations.json", @headers
    expect_status(204)
  end

  it 'Get Network importJobs by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/ImportJobs.json", @headers
    expect_status(200)
    expect_json_keys('d.results.0', [:Id, :Status, :Total, :Success, :Fail, :Error])
  end

  it 'Get Network notificationEndpoints by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/NotificationEndpoints.json", @headers
    expect_status(200)
  end

  it 'Get Network OAuthApplications by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/OAuthApplications.json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id, :NetworkId, :Name, :RedirectUri, :Uid, :Secret, :CreatedAt])
  end

  it 'Get Network products by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/Products.json", @headers
    expect_status(200)

    expect_json_keys('d.results.0', [:Id, :Code, :Name, :Description, :Summary])
    expect_json_types('d.results.0', Id: :string)
  end

  it 'Get Network ProfileFields by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/ProfileFields.json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id, :FieldName, :IsPublic, :IsUsed, :IsRequired, :NoShow, :FieldSection])
  end

  it 'Get Network recentMentionProducts by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/RecentMentionProducts.json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id, :Code, :Name, :Description, :Summary, :Manufacturer, :ProductImage])
  end

  it 'Get Network RecentPosts by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/RecentPosts.json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id,
                                    :OriginalContent,
                                    :RawOriginalContent,
                                    :HtmlContent,
                                    :IsPostVisible,
                                    :ModerationStatus,
                                    :HighlightedOriginalContent,
                                    :PostId,
                                    :ParentPostId,
                                    :Depth,
                                    :IsFeatured,
                                    :PublishedAt,
                                    :CreatedAt,
                                    :UpdatedAt,
                                    :Traits,
                                    :FollowedByLoggedInUser,
                                    :FlaggedByLoggedInUser,
                                    :Permissions])
  end

  it 'Get Network remoteSyncReports by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/RemoteSyncReports.json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id, :NetworkId, :Status, :DataModel, :DataStartAt, :DataEndAt, :RemoteSystemId])
  end

  it 'Get Network remoteSystems by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/RemoteSystems.json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id, :SystemName, :BaseUrl, :Username, :Password, :JsonInfo, :NetworkId])
  end

  it 'Get Network reports by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/Reports.json", @headers
    expect_status(200)

    expect_json_keys('d.results', [:Id])
    expect_json_types('d.results', Id: :string)
  end

  it 'Get Network ScheduleJobs(HybrisSyncJob) by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/ScheduleJobs.json?JobName=HybrisSyncJob", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id,
                                     :NetworkId,
                                     :At,
                                     :CreatorId,
                                     :Frequency,
                                     :Name,
                                     :Nday,
                                     :StartDate,
                                     :FullName,
                                     :Tz,
                                     :CreatedAt,
                                     :UpdatedAt])
  end

  it 'Get Network ScheduleJobs(HybrisMarketingJob) by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/ScheduleJobs.json?JobName=HybrisMarketingJob", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id,
                                     :NetworkId,
                                     :At,
                                     :CreatorId,
                                     :Frequency,
                                     :Name,
                                     :Nday,
                                     :StartDate,
                                     :FullName,
                                     :Tz,
                                     :CreatedAt,
                                     :UpdatedAt])
  end

  # it 'Get Network searchLayout by Network ID' do
  #   get "#{@api_base_url}/Networks('#{@network_id_get}')/SearchLayout.json", @headers
  #   expect_status(200)
  #
  #   expect_json_keys('d.results', [:Id, :CreatorId, :PageName, :LayoutName, :Config])
  #   expect_json_types('d.results', Id: :string)
  # end

  it 'Get Network searchedPosts by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/SearchedPosts.json", @headers
    expect_status(204)
  end

  it 'Get Network Topics by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/Topics.json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id,
                                    :TopicSort,
                                    :UpdatedAt,
                                    :Title,
                                    :Caption,
                                    :TopicType,
                                    :IsFeatured,
                                    :IsActive,
                                    :IsBeingEdited,
                                    :HasAds,
                                    :AnsweredQuestions,
                                    :ReviewRating,
                                    :ReviewDetail,
                                    :ReviewCount,
                                    :RecommendedDetail,
                                    :PostsCount,
                                    :DraftTwinId,
                                    :FollowersCount,
                                    :QuestionCount,
                                    :BlogCount,
                                    :DiscussionCount,
                                    :ConvsSinceLastVisit,
                                    :WidgetOrder,
                                    :FollowedByLoggedInUser,
                                    :BannerUrl,
                                    :TileUrl,
                                    :TopicAvatarSizeThreeHundredOneSeventyUrl,
                                    :TopicAvatarSizeSixtyFortyUrl])
  end

  it 'Get Network WidgetComponents by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/WidgetComponents.json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id,
                                    :Name,
                                    :NetworkId,
                                    :ThumbnailCss,
                                    :Key,
                                    :CreatedAt,
                                    :UpdatedAt])
  end

  it 'Get Network widgetConversations by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/WidgetConversations.json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id,
                                     :Title,
                                     :HighlightedTitle,
                                     :OriginalContent,
                                     :HtmlContent])
  end

  it 'Get Network widgetThemeTemplates by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/WidgetThemeTemplates.json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id,
                                     :BackgroundColor,
                                     :BodyFont,
                                     :BodyFontColor,
                                     :BodyFontSize])
  end

  it 'Get Network flaggedPosts by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/FlaggedPosts().json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id,
                                     :OriginalContent,
                                     :RawOriginalContent,
                                     :HtmlContent,
                                     :IsPostVisible])
  end

  it 'Get Network removedPosts by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/RemovedPosts().json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id,
                                     :OriginalContent,
                                     :RawOriginalContent,
                                     :HtmlContent,
                                     :IsPostVisible])
  end

  it 'Get Network pendingApprovalPosts by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/PendingApprovalPosts().json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id,
                                     :OriginalContent,
                                     :RawOriginalContent,
                                     :HtmlContent,
                                     :IsPostVisible])
  end

  it 'Get Network topicsForAdministration by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/TopicsForAdministration().json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id,
                                     :TopicSort,
                                     :UpdatedAt,
                                     :Title,
                                     :Caption])
  end

  it 'Get Network postableTopics by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/PostableTopics().json", @headers
    expect_status(200)
    expect_json_keys('d.results.*', [:Id,
                                     :TopicSort,
                                     :UpdatedAt,
                                     :Title,
                                     :Caption])
  end

  it 'Preview branding of network by Network ID' do
    body = {"d":{"branding_metadata":"'{\"primary_button_color\":\"#009de0\",\"primary_button_text\":\"#ffffff\",\"link_color\":\"#009de0\",\"link_color_hover\":\"#0079ad\",\"light_link_color\":\"#6bcbff\",\"light_link_color_hover\":\"#1fb0ff\",\"horizontal_line_color\":\"#dddddd\",\"navbar_color\":\"#0086d4\",\"navbar_gradient_top\":\"#ffffff\",\"navbar_gradient_bottom\":\"#f0f0f0\",\"navbar_text\":\"#00679e\",\"navbar_text_select\":\"#777777\",\"font_family\":\"Arial, Helvetica, sans-serif\",\"favicon_url\":\"\",\"headers_font_family\":\"Arial, Helvetica, sans-serif\",\"header_color\":\"#333333\",\"banner_title_color\":\"#ffffff\",\"banner_breadcrumb_nav_color\":\"#ffffff\",\"subnav_text_color\":\"#333333\",\"subnav_background_color\":\"#f7f7f7\",\"subnav_link_underline\":\"#009de0\",\"subnav_hoverlink_underline\":\"#009de0\",\"livechat_title_color\":\"#ffffff\",\"livechat_title_background_color\":\"#007cc0\",\"livechat_window_background_color\":\"#f2f2f2\",\"concatenated_properties\":[]}'"}}
    post "#{@api_base_url}/Networks('#{@network_id_get}')/PreviewBranding().json", body, @headers
    expect_status(204)
  end

  it 'Publish branding for network by Network ID' do
    body = {"d":{}}
    post "#{@api_base_url}/Networks('#{@network_id_get}')/PublishBranding().json", body, @headers
    expect_status(204)
  end

  it 'Publish disclosures for network by Network ID' do
    body = {"d":{}}
    post "#{@api_base_url}/Networks('#{@network_id_get}')/PublishDisclosures().json", body, @headers
    expect_status(204)
  end

  it 'Set name for network by Network ID' do
    body = {"d":{}}
    post "#{@api_base_url}/Networks('#{@network_id_get}')/SetName().json", body, @headers
    expect_status(204)
  end

  it 'Update integration configuration for network by Network ID' do
    body = {"d": {"IntegrationConf": "{\"active\":\"hybrisOnPremise\",\"isOnDemandSync\":false,\"hybrisOnPremise\":{\"title\":\"candidate\",\"baseUrl\":\"https://electronics-b2c.mo.sap.corp:9002\",\"baseWebPrefix\":\" /yacceleratorstorefront/en\",\"baseProductsApi\":\"/rest/v2/electronics/products/search\",\"baseProductApi\":\"/rest/v2/electronics/products\",\"checkoutUrl\":\"/electronics/{lang}/cart\"},\"hybrisCloud\":{}}"},
            "IntegrationSource":"hybris"}
    post "#{@api_base_url}/Networks('#{@network_id_get}')/UpdateIntegrationConfig().json", body, @headers
    expect_status(204)
  end

  it 'Sync with integration configuration for network by Network ID' do
    body = {"d": {"IntegrationConf": "{\"active\":\"hybrisOnPremise\",\"isOnDemandSync\":false,\"hybrisOnPremise\":{\"title\":\"candidate\",\"baseUrl\":\"https://electronics-b2c.mo.sap.corp:9002\",\"baseWebPrefix\":\" /yacceleratorstorefront/en\",\"baseProductsApi\":\"/rest/v2/electronics/products/search\",\"baseProductApi\":\"/rest/v2/electronics/products\",\"checkoutUrl\":\"/electronics/{lang}/cart\"},\"hybrisCloud\":{}}"},
            "IntegrationSource":"hybris"}
    post "#{@api_base_url}/Networks('#{@network_id_get}')/SyncWithIntegrationConfig().json", body, @headers
    expect_status(204)
  end

  it 'Create on demand conversation for network by Network ID' do
    body = {"d":{"HtmlContent":"<p>test</p>","OriginalContent":"test","Title":"test question","TypeTrait":"question","ProductCode":"1377492"}}
    post "#{@api_base_url}/Networks('#{@network_id_get}')/OnDemandConversation().json", body, @headers
    expect_status(204)
  end

  it 'Create on demand topic for network by Network ID' do
    body = {"d":{"HtmlContent":"<p>test</p>","OriginalContent":"test","Title":"test question","TypeTrait":"question","ProductCode":"1377492"}}
    post "#{@api_base_url}/Networks('#{@network_id_get}')/OnDemandTopic().json", body, @headers
    expect_status(204)
  end

  it 'Create on demand topic for network by Network ID' do
    body = {"d":{"Title":"test","HtmlContent":"<p>test<p>","OriginalContent":"test","TypeTrait":"review","ProductCode":"1978440_blue","RatingValue":"5","Recommended":true}}
    post "#{@api_base_url}/Networks('#{@network_id_get}')/OnDemandTopic().json", body, @headers
    expect_status(204)
  end

  it 'Update analytics on network by Network ID' do
    body = {"d": {}}
    post "#{@api_base_url}/Networks('#{@network_id_get}')/UpdateAnalytics().json", body, @headers
    expect_status(204)
  end

  it 'Update hybris addon version by Network ID' do
    body = {"d": {}}
    post "#{@api_base_url}/Networks('#{@network_id_get}')/UpdateHybrisAddonVersion().json", body, @headers
    expect_status(204)
  end

  it 'Update embedding contents by Network ID' do
    body = {"d":{"EmbeddingContentProvider":"google_ads","EmbeddingContentId":"ca-pub-8464600688944785","EmbeddingContentParams":{"embeddingContentBannerParams":"7717419156","embeddingContentSideParams":"9115119620"}}}
    post "#{@api_base_url}/Networks('#{@network_id_get}')/UpdateEmbeddingContents().json", body, @headers
    expect_status(204)
  end

  it 'Import profanity list on network by Network ID' do
    body = {:multipart => true, :file => File.new(@config.data_dir + '/import_tag.csv', "rb")}
    post "#{@api_base_url}/Networks('#{@network_id_get}')/ImportProfanityList().json", body, @headers
    expect_status(204)
  end

  it 'Enable profanity blocker on network by Network ID' do
    body = {"d":{}}
    post "#{@api_base_url}/Networks('#{@network_id_get}')/EnableProfanityBlocker().json", body, @headers
    expect_status(204)
  end

  it 'Disable profanity blocker on network by Network ID' do
    body = {"d":{}}
    post "#{@api_base_url}/Networks('#{@network_id_get}')/DisableProfanityBlocker().json", body, @headers
    expect_status(204)
  end

  it 'Get Network generateKeys by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/GenerateKeys().json", @headers
    expect_status(200)
    expect_json_keys('d.results', [:Id,
                                     :Issuer,
                                     :Url,
                                     :NetworkId])
  end

  it 'Create notification this weeks on the network by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/NotificationsThisWeek().json", @headers
    expect_status(200)
  end

  it 'Create notification prior to this week on the network by Network ID' do
    get "#{@api_base_url}/Networks('#{@network_id_get}')/NotificationsPriorToThisWeek().json", @headers
    expect_status(200)
  end

  it 'Get monthly cta count by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/MonthlyCtaCount()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Day, :Hits, :Date, :RegisteredUserCount, :AnonUserCount]
    )
    expect_json_types(
      '*', Hits: :int
    )
  end

  it 'Get weekly cta count by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/WeeklyCtaCount()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Day, :Hits, :Date, :RegisteredUserCount, :AnonUserCount]
    )
    expect_json_types(
      '*', Hits: :int
    )
  end

  it 'Get monthly hybris cta count by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/MonthlyHybrisCtaCount()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Day, :Hits, :Date, :RegisteredUserCount, :AnonUserCount]
    )
    expect_json_types(
      '*', Hits: :int
    )
  end

  it 'Get weekly hybris cta count by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/WeeklyHybrisCtaCount()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Day, :Hits, :Date, :RegisteredUserCount, :AnonUserCount]
    )
    expect_json_types(
      '*', Hits: :int
    )
  end

  it 'Get deily page view count by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/DailyPageViewCount()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Day, :Hits, :Date, :RegisteredUserCount, :AnonUserCount]
    )
    expect_json_types(
      '*', Hits: :int, Day: :int
    )
  end

  it 'Get weekly page view count by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/WeeklyPageViewCount()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Day, :Hits, :Date, :RegisteredUserCount, :AnonUserCount]
    )
    expect_json_types(
      '*', Hits: :int, Day: :int
    )
  end

  it 'Get monthly page view count by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/MonthlyPageViewCount()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Day, :Hits, :Date, :RegisteredUserCount, :AnonUserCount]
    )
    expect_json_types(
      '*', Hits: :int, Day: :string, Date: :string
    )
  end

  it 'Get yearly page view count by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/YearlyPageViewCount()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Hits, :Date]
    )
    expect_json_types(
      '*', Hits: :int, Date: :string
    )
  end

  it 'Get daily registered user count by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/DailyRegisteredUserCount()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Day, :Hits, :Date, :RegisteredUserCount, :AnonUserCount]
    )
    expect_json_types(
      '*', Hits: :int, Day: :string, Date: :string
    )
  end

  it 'Get weekly registered user count by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/WeeklyRegisteredUserCount()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Day, :Hits, :Date, :RegisteredUserCount, :AnonUserCount]
    )
    expect_json_types(
      '*', Hits: :int, Day: :string, Date: :string
    )
  end

  it 'Get monthly registered user count by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/MonthlyRegisteredUserCount()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Day, :Hits, :Date, :RegisteredUserCount, :AnonUserCount]
    )
    expect_json_types(
      '*', Hits: :int, Day: :string, Date: :string
    )
  end

  it 'Get popular topics last 7 days by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/PopularTopicsLast7Days()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Label,:Value,:ShortLabel,:ContentLink,:StartDate,:EndDate]
    )
    expect_json_types(
      '*', Label: :string, Value: :int
    )
  end

  it 'Get popular topics last 30 days by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/PopularTopicsLast30Days()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Label,:Value,:ShortLabel,:ContentLink,:StartDate,:EndDate]
    )
    expect_json_types(
      '*', Label: :string, Value: :int
    )
  end

  it 'Get popular conversation last 7 days by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/PopularConversationsLast7Days()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Label,:Value,:ShortLabel,:ContentLink,:StartDate,:EndDate]
    )
    expect_json_types(
      '*', Label: :string, Value: :int
    )
  end

  it 'Get popular conversation last 30 days by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/PopularConversationsLast30Days()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Label,:Value,:ShortLabel,:ContentLink,:StartDate,:EndDate]
    )
    expect_json_types(
      '*', Label: :string, Value: :int
    )
  end

  it 'Get referers last 30 days by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/ReferersLast30Days()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Label,:Value,:ShortLabel,:ContentLink,:StartDate,:EndDate]
    )
    expect_json_types(
      '*', Label: :string, Value: :int
    )
  end

  it 'Get referers last 7 days by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/ReferersLast7Days()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Label,:Value,:ShortLabel,:ContentLink,:StartDate,:EndDate]
    )
    expect_json_types(
      '*', Label: :string, Value: :int
    )
  end

  it 'Get unique participants per topic by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/UniqueParticipantsPerTopic()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:TopicTitle,:Posts,:UniqueParticipants,:PostedByGeneral,:PostedByAdministrators,:PostedByModerators,:TopicUrl]
    )
    expect_json_types(
      '*', TopicTitle: :string, Posts: :int, UniqueParticipants: :int
    )
  end

  it 'Get new posts accoss all topics by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/NewPostsAcrossAllTopics()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:TopicTitle,:Posts,:UniqueParticipants,:PostedByGeneral,:PostedByAdministrators,:PostedByModerators,:TopicUrl]
    )
    expect_json_types(
      '*', TopicTitle: :string, PostedByGeneral: :int, TopicUrl: :string
    )
  end

  it 'Get elapsed time between posts by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/ElapsedTimeBetweenPosts()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Label,:Value,:ShortLabel,:ContentLink,:StartDate,:EndDate]
    )
    expect_json_types(
      '*', Label: :string, Value: :int
    )
  end

  it 'Get daily returning users count by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/DailyReturningUsersCount()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Day, :Hits, :Date, :RegisteredUserCount, :AnonUserCount]
    )
    expect_json_types(
      '*', RegisteredUserCount: :int
    )
  end

  it 'Get weekly returning users count by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/WeeklyReturningUsersCount()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Day, :Hits, :Date, :RegisteredUserCount, :AnonUserCount]
    )
    expect_json_types(
      '*', RegisteredUserCount: :int
    )
  end

  it 'Get monthly returning users count by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/MonthlyReturningUsersCount()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Day, :Hits, :Date, :RegisteredUserCount, :AnonUserCount]
    )
    expect_json_types(
      '*', RegisteredUserCount: :int
    )
  end

  it 'Get yearly returning users count by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/YearlyReturningUsersCount()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:Day, :Hits, :Date, :RegisteredUserCount, :AnonUserCount]
    )
    expect_json_types(
      '*', RegisteredUserCount: :int
    )
  end

  it 'Get weekly post count from the new registered users by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/WeeklyNewRegisteredUsersPostCount()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:MembersWithZeroPosts,:MembersWithOnePost,:MembersWithManyPosts,:Date,:MemberCount]
    )
     expect_json_types(
      '*', MembersWithZeroPosts: :int, MembersWithOnePost: :int, Date: :string
    )
  end

  it 'Get monthly post count from the new registered users by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/MonthlyNewRegisteredUsersPostCount()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:MembersWithZeroPosts,:MembersWithOnePost,:MembersWithManyPosts,:Date,:MemberCount]
    )
     expect_json_types(
      '*', MembersWithZeroPosts: :int, MembersWithOnePost: :int, Date: :string
    )
  end

  it 'Get yearly post count from the new registered users by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/YearlyNewRegisteredUsersPostCount()", @headers
    expect_status(200)
    expect_json_keys(
      '*',[:MembersWithZeroPosts,:MembersWithOnePost,:MembersWithManyPosts,:Date,:MemberCount]
    )
     expect_json_types(
      '*', MembersWithZeroPosts: :int, MembersWithOnePost: :int, Date: :string
    )
  end

  it 'Update page view on network' do
    body = {"d":{"PageUrl": "/n/#{@config.slug}/home"}}
    post "#{@api_base_url}/Networks('#{@config.slug}')/UpdatePageView()", body, @headers
    expect_status(204)
  end

  it 'Get capabilities by network slug' do
    get "#{@api_base_url}/Networks('#{@config.slug}')/Capabilities()", @headers
    expect_status(200)
    expect_json_keys(
      [:Access,:ConfigureLms,:ConfigureBranding,:SetLayout,:ModeratePosts,:ModifyConfiguration,:SetupTopics,:ConfigureProfileFields,:ModifyPermissionGroups,:OauthAdministration,:SetDisclosures,:ViewReporting,:MarketingSync,:EcommerceIntegration,:WidgetTheme,:IdpConfiguration,:SubscribeToWebhooks,:ManageBusinessTemplate]
    )
    expect_json_types(
      Access: :boolean, ConfigureBranding: :boolean, SetLayout: :boolean, ModifyConfiguration: :boolean
    )
  end

  it 'Acknowledge policy on network' do
    body = {"d":{}}
    post "#{@api_base_url}/Networks('#{@config.slug}')/AcknowledgePolicy()", body, @headers
    expect_status(204)
  end

  it 'Reset acknowledgements on network' do
    body = {"d":{}}
    post "#{@api_base_url}/Networks('#{@config.slug}')/ResetAcknowledgements()", body, @headers
    expect_status(204)
  end

  it 'Toggle the admin view to widget only scenario' do
    body = {"d":{}}
    post "#{@api_base_url}/Networks('#{@config.slug}')/ToggleAdminView()", body, @headers
    expect_status(204)
  end

  it 'Enable BusinessTemplate' do
    response = get "#{@api_base_url}/Networks('#{@config.slug}')/BusinessTemplates.json", @headers
    expect_status(200)
    id = JSON.parse(response)['d']['results'][0]['Id']
    body = {"d":{"Id": id}}
    post "#{@api_base_url}/Networks('#{@config.slug}')/EnableBusinessTemplate()", body, @headers
    expect_status(204)
  end

  it 'Update Notifications (Webhooks)' do
    #body can be email/bell:true/false
    body = {"d":{"email":false}}
    post "#{@api_base_url}/Networks('#{@config.slug}')/UpdateNotifications()", body, @headers
    expect_status(204)
  end

  it 'Import Tags' do
    #upload_file :header=>@headers,:url=>"#{@config.base_url}#{@api_base_url}/Networks('#{@config.slug}')/ImportTagsList()", :file_name=>@config.data_dir + '/import_tag.csv'
    body = {:multipart => true, :file => File.new(@config.data_dir + '/import_tag.csv', "rb")}
    post "#{@api_base_url}/Networks('#{@config.slug}')/ImportTagsList()", body, @headers
    expect_status(204)
  end

  it 'Save/Search/Delete Tags' do
    tag = "apitest#{Time.now.utc.to_i}"

    # save tag
    save_body = {"d":{"tags": tag}}
    post "#{@api_base_url}/Networks('#{@config.slug}')/SaveTags()", save_body, @headers
    expect_status(204)

    # search tag
    response = get "#{@api_base_url}/Networks('#{@config.slug}')/SearchTags()?keyword=#{tag}&$top=81&$skip=0&$format=json", @headers
    expect_status(200)
    expect_json_keys(
      "d.results.*",[:Id, :Name, :CreatorId, :UpdaterId, :CreatedAt, :UpdatedAt]
    )
    expect_json_types(
      "d.results.*", Id: :string, Name: :string
    )

    # delete tag
    results = JSON.parse(response)['d']['results']
    id = results[results.index{|x| x["Name"] == tag}]["Id"]
    body = {"d":{"uuids": id}}
    post "#{@api_base_url}/Networks('#{@config.slug}')/DeleteTags()", body, @headers
    expect_status(204)
  end

  it 'Get a specific NetworkConfiguration' do
    get "#{@api_base_url}/NetworkConfigurations('#{@network_id_get}')", @headers
    expect_status(200)
    expect_json_keys(
      "d.results", [:Id, :ModerationThreshold, :ModerationType]
    )
    expect_json_types(
      "d.results", ModerationThreshold: :int, ModerationType: :string
    )
  end

end
