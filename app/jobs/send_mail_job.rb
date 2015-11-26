class SendMailJob
  include SuckerPunch::Job

  def perform(object, method, param)
    object.send(method, param).deliver_now
  end

  def perform_with_user(object, method, param, current_user)
    object.send(method, param, current_user).deliver_now
  end
end
