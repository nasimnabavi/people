class SendMailJob
  include SuckerPunch::Job

  def perform(object, method, param)
    object.send(method, param).deliver
  end

  def perform_with_user(object, method, param, current_user)
    object.send(method, param, current_user).deliver
  end
end
