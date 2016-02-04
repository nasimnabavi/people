shared_examples 'has timeline visible' do
  it 'shows timeline' do
    sleep 5
    expect(page).to have_css('.timeline .events')
  end
end

shared_examples 'has timeline event visible' do
  it 'shows timeline event' do
    sleep 5
    expect(page).to have_css('.event .time')
  end
end
