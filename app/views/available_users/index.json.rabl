collection @users

cache "available_users_#{User.cache_key}_#{Project.cache_key}_#{Membership.cache_key}_#{locals[:cache_key]}"

extends "available_users/base"
extends "available_users/extra_info"
