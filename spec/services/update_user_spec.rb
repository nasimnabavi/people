require 'spec_helper'

describe UpdateUser do
  let(:user) { create(:user) }
  let(:current_user) { create(:user, :admin) }
  let(:params) do
    {
      'first_name' => 'John',
      'ability_ids' => ['']
    }
  end
  let(:send_mail_with_user_job) { SendMailWithUserJob }

  it 'updates user attributes' do
    expect do
      described_class.new(user, params, current_user).call
    end.to change { user.first_name }.from(user.first_name).to(params['first_name'])
  end

  context 'new ability' do
    it 'creates new abilities' do
      params['ability_ids'] << 'rails'

      expect do
        described_class.new(user, params, current_user).call
      end.to change { user.abilities.count }.from(0).to(1)
    end
  end

  context 'ability removed' do
    it 'removes existing ability from the user' do
      user.abilities << create(:ability)

      expect do
        described_class.new(user, params, current_user).call
      end.to change { user.abilities.count }.from(1).to(0)
    end
  end

  context 'notifications about changes send' do
    before do
      allow(SendMailWithUserJob).to receive(:new).and_return(send_mail_with_user_job)
    end

    it 'sends email if location changed' do
      expect(send_mail_with_user_job).to receive(:perform).with(
        UserMailer, :notify_admins_about_changes, user, current_user.id
      ).once

      described_class.new(user, { location_id: 99 }, current_user).call
    end

    it 'sends email if employment changed' do
      expect(send_mail_with_user_job).to receive(:perform).with(
        UserMailer, :notify_admins_about_changes, user, current_user.id
      ).once

      described_class.new(user, { employment: user.employment + 10 }, current_user).call
    end

    it 'sends email if user_notes_changed changed' do
      expect(send_mail_with_user_job).to receive(:perform).with(
        UserMailer, :notify_admins_about_changes, user, current_user.id
      ).once

      described_class.new(user, { user_notes: 'This test is great!' }, current_user).call
    end
  end

  context 'notifications about changes not send' do
    it "doesn't send an email if location or employment weren't updated" do
      expect(send_mail_with_user_job).to receive(:perform).with(
        UserMailer, :notify_admins_about_changes, user, current_user.id
      ).exactly(0).times

      described_class.new(user, params, current_user).call
    end

    it "doesn't send an email if validation fails" do
      expect(send_mail_with_user_job).to receive(:perform).with(
        UserMailer, :notify_admins_about_changes, user, current_user.id
      ).exactly(0).times

      described_class.new(user, { employment: 2000 }, current_user).call
    end
  end
end
