class SendMailJob
  include SuckerPunch::Job

  def perform(object, method, param)
    object.send(method, param).deliver_now
  end
end
