shared_examples 'has timeline visible' do
  it 'shows timeline' do
    expect(page).to have_css('.timeline .events')
  end
end

shared_examples 'has timeline event visible' do
  it 'shows timeline event' do
    expect(page).to have_css('.event .time')
  end
end
