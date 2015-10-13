import React from 'react';

class StatisticsSearch extends React.Component {
  static get propTypes() {
    return {
      onFormSubmit: React.PropTypes.func.isRequired,
      initDate: React.PropTypes.string.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = { date: props.initDate };
    this.onFormSubmit = this.onFormSubmit.bind(this);
  }

  onFormSubmit() {
    var dateValue = this.refs.statisticsDate.getDOMNode().value;
    this.state.date = dateValue;
    this.props.onFormSubmit(this.state.date);
  }

  render() {
    return (
      <form onChange={this.onFormSubmit}>
        <div className='form-group'>
          <input ref='statisticsDate' className='form-control' type='month' value={this.state.date}/>
        </div>
      </form>
    );
  }
}

export default StatisticsSearch;
