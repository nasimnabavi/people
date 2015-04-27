require 'spec_helper'

describe 'profile', js: true do
  let!(:junior) { create(:role, name: 'junior', priority: 2) }
  let!(:developer) { create(:role, name: 'developer', priority: 1) }
  let(:position) { create(:position, role: junior) }

  before do
    page.set_rack_session 'warden.user.user.key' => User
      .serialize_into_session(position.user).unshift('User')
  end

  describe 'setting primary role' do
    before { visit user_path(position.user.id) }

    it 'set primary role to a user' do
      expect(page).to have_select('js-user-primary', selected: 'no role')
      select(position.role.name, from: 'js-user-primary')

      within('form.edit_user') do
        first('input[type=submit]').click
      end

      expect(page).to have_select('js-user-primary', selected: position.role.name)
    end
  end

  describe 'adding positions' do
    before { visit user_path(position.user.id) }

    it 'adds a position to user' do
      expect(page).to have_select('js-user-primary', options: ['no role', 'junior'])

      within('form.edit_user') do
        click_link('Add position')
      end

      within('form.new_position') do
        select(developer.name, from: 'position_role_id')
        select("#{position.user.last_name} #{position.user.first_name}",
          from: 'position_user_id')

        fill_in('position_starts_at',
          with: (position.starts_at + 1.year).strftime("%Y-%m-%d"))

        click_button('Create Position')
      end

      expect(page).to have_select('js-user-primary',
        options: ['no role', 'junior', 'developer'])
    end
  end
end
