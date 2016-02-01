class SendMailWithUserJob
  include SuckerPunch::Job

  def perform(object, method, param, current_user_id)
    object.send(method, param, User.find(current_user_id)).deliver_now
  end
end
