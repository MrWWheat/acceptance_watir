require 'actions/base'

class Actions::Api < Actions::Base

  def initialize(config)
    super(config)
  end

  def delete_review(user, uuid)
    @config.api.establish_session(user)
    @config.api.delete(user, "/api/v1/OData/Conversations('#{uuid}')?$expand=PageLayout")
    puts "Delete review #{uuid}"
  end

  def is_user_mapped?(hybris_user, community_user)
    @c.api.establish_session(community_user)
    hybris_user.email == @c.api.get_mapping_uid_for_user(community_user)
  end

  def break_mapping(community_user)
    uuid = @c.api.get_uuid_for_user(community_user)
    @config.api.post(community_user, "/api/v1/OData/Members('#{uuid}')/BreakMapping()")
    puts "Break user mapping for #{community_user.email}"
  end

  def promote_user_as_blogger(admin, user_id)
    @config.api.establish_session(admin)
    @config.api.post(admin, "/api/v2/role_members/network/blogger/#{user_id}")
    puts "Promote user #{user_id} as blogger"
  end 

  def remove_user_from_blogger(admin, user_id)
    @config.api.establish_session(admin)
    @config.api.delete(admin, "/api/v2/role_members/network/blogger/#{user_id}")
    puts "Remove user #{user_id} as blogger"
  end

  def promote_user_role_with_network_scope(admin:, user_id:, role: :admin)
    @config.api.establish_session(admin)
    response = @config.api.get(admin, "/api/v2/role_members/network/#{role}/#{user_id}")
    return unless response['data'].nil?
    @config.api.post(admin, "/api/v2/role_members/network/#{role}/#{user_id}")
    puts "promote user #{user_id} as network #{role}"
  end

  def promote_user_role_with_topic_scope(admin:, user_id:, topic_id:, role: :admin)
    @config.api.establish_session(admin)
    response =  @config.api.get(admin, "/api/v2/role_members/topics/#{topic_id}/#{role}/#{user_id}")
    return unless response['data'].nil?
    @config.api.post(admin, "/api/v2/role_members/topics/#{topic_id}/#{role}/#{user_id}")
    puts "promote user #{user_id} as topic #{topic_id} #{role}"
  end

  def remove_user_role_from_network_scope(admin:, user_id:, role: :admin)
    @config.api.establish_session(admin)
    response = @config.api.get(admin, "/api/v2/role_members/network/#{role}/#{user_id}")
    return if response['data'].nil?
    @config.api.delete(admin, "/api/v2/role_members/network/#{role}/#{user_id}")
    puts "Remove user #{user_id} as network #{role}"
  end

  def remove_user_role_from_topic_scope(admin:, user_id:, topic_id:, role: :admin)
    @config.api.establish_session(admin)
    response = @config.api.get(admin, "/api/v2/role_members/topics/#{topic_id}/#{role}/#{user_id}")
    return if response['data'].nil?
    @config.api.delete(admin, "/api/v2/role_members/topics/#{topic_id}/#{role}/#{user_id}")
    puts "Remove user #{user_id} as topic #{topic_id} #{role}"
  end 
end