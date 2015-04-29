class NoteMailer < BaseMailer
  def note_added(note)
    @note = note
    @project = note.project
    @user = note.user.decorate

    to = [@project.pm.try(:email), AppConfig.emails.pm].compact.uniq
    mail(to: to,
         subject: "New note added to #{ @project.name }.",
         project: @project,
         note: @note,
         user: @user)
  end
end
