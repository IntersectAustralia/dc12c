module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

      when /^the home\s?page$/
        '/'

      # User paths
      when /the login page/
        new_user_session_path

      when /the logout page/
        destroy_user_session_path

      when /the user profile page/
        users_profile_path

      when /the request account page/
        new_user_registration_path

      when /the edit my details page/
        edit_user_registration_path

      when /^the user details page for (.*)$/
        user_path(User.where(:email => $1).first)

      when /^the edit role page for (.*)$/
        edit_role_user_path(User.where(:email => $1).first)

      when /^the reset password page$/
        edit_user_password_path

      # Users paths
      when /the access requests page/
        access_requests_users_path

      when /the list users page/
        users_path

      when /the "MQT (.*)" papyrus page/
        p = Papyrus.find_by_mqt_number! $1
        papyrus_path p

      when /the "MQT (.*)" edit papyrus page/
        p = Papyrus.find_by_mqt_number! $1
        edit_papyrus_path p

      when /the list papyri page/
        papyri_path

      when /page (.*) of the papyri index/
        page_num = $1
        papyri_path page: page_num

      when /the search results page/
        search_papyri_path

      when /the advanced search page/
        advanced_search_papyri_path

      when /the admin page/
        admin_index_path

      when /the upload image page for "MQT (.*)"/
        new_papyrus_image_path(Papyrus.find_by_mqt_number!($1))

      when /the papyrus "MQT (.*)" image "(.*)" "(.*)" page/
        papyrus = Papyrus.find_by_mqt_number!($1)
        image = papyrus.images.find_by_image_file_name!($2)
        style = $3
        image.image.url(style.to_sym)

      when /the list requests page/
        access_requests_path

      when /the papyrus access request page for "(.*)" and papyrus "MQT (.*)"/
        user = User.find_by_email! $1
        papyrus = Papyrus.find_by_mqt_number! $2
        access_request = AccessRequest.find_by_user_id_and_papyrus_id!(user.id, papyrus.id)
        access_request_path(access_request)

      when /the list pending requests page/
        pending_access_requests_path

      when /page (.*) of the list approved requests index/
        page_num = $1
        approved_access_requests_path page: page_num

      when /the revoke access request page/
        revoke_access_request_path


# Add more mappings here.
# Here is an example that pulls values out of the Regexp:
#
#   when /^(.*)'s profile page$/i
#     user_profile_path(User.find_by_login($1))

      else
        begin
          page_name =~ /^the (.*) page$/
          path_components = $1.split(/\s+/)
          self.send(path_components.push('path').join('_').to_sym)
        rescue NoMethodError, ArgumentError
          raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
                    "Now, go and add a mapping in #{__FILE__}"
        end
    end
  end
end

World(NavigationHelpers)
