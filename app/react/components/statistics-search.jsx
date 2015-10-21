import React from 'react';

class StatisticsSearch extends React.Component {
  static get propTypes() {
    return {
      onFormSubmit: React.PropTypes.func.isRequired,
      initDate: React.PropTypes.string.isRequired,
      epochInitDate: React.PropTypes.number.isRequired
    };
  }

  constructor(props) {
    super(props);
    this.state = { date: props.initDate, epochDate: props.epochInitDate };
    this.onFormSubmit = this.onFormSubmit.bind(this);
    this.onSliderChange = this.onSliderChange.bind(this);
    this.onDateChange = this.onDateChange.bind(this);
  }

  onFormSubmit() {
    this.props.onFormSubmit(this.state.date);
  }

  onSliderChange() {
    const inputValue = this.refs.statisticsSlider.getDOMNode().value;
    if(inputValue == this.state.epochDate) return;
    this.state.epochDate = inputValue;
    this.state.date = this.epochToStringDate(inputValue);
    this.onFormSubmit()
  }

  onDateChange() {
    const input = this.refs.statisticsDate.getDOMNode();
    this.state.date = input.value;
    this.state.epochDate = input.valueAsNumber;
    this.onFormSubmit()
  }

  epochToStringDate(epochDate) {
    return (1970 + parseInt(epochDate / 12)) + '-' + ('0' + (epochDate % 12 + 1)).slice(-2)
  }

  render() {
    return (
      <form>
        <div className='form-group'>
          <input ref='statisticsSlider' onChange={this.onSliderChange} className='statistic-slider'
            type='range' min='479' max={this.props.epochInitDate + 18} value={this.state.epochDate}/>
          <input ref='statisticsDate' onChange={this.onDateChange} className='form-control'
            type='month' value={this.state.date}/>
        </div>
      </form>
    );
  }
}

export default StatisticsSearch;
