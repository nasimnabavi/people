import React from 'react';
import Statistic from './statistic'

class Statistics extends React.Component {
  static get propTypes() {
    return {
      token: React.PropTypes.string.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      statistics: {
        commercialProjectsNumber: 0,
        internalProjectsNumber: 0,
        projectsEndingThisMonthNumber: 0,
        beginningNextMonthProjectsNumber: 0
      },
      date: (new Date).getFullYear() + '-' + ((new Date).getMonth() + 1)
    };
  }

  componentDidMount() {
    this._fetchStatistics()
  }

  _fetchStatistics() {
    $.ajax({
      url: Routes.api_v2_statistics_path(),
      dataType: 'json',
      data: {
        date: this.state.date,
        token: this.props.token
      }
    }).done(this._fetchDataDone.bind(this)).fail(this._fetchDataFail);
  }

  _fetchDataDone(data, textStatus, jqXHR) {
    this.setState({statistics: data});
  }

  _fetchDataFail(xhr, status, err) {
    console.error(Routes.api_v2_statistics_path(), status, err.toString());
  }

  _handleOnSubmit(e) {
    e.preventDefault();

    var dateValue = this.refs.statisticsDate.getDOMNode().value;
    this.state.date = dateValue;
    this._fetchStatistics();
  }

  render() {
    return (
      <div>
        <form onChange={this._handleOnSubmit.bind(this)}>
          <div className='form-group'>
            <input ref='statisticsDate' className='form-control' type='month' value={this.state.date}/>
          </div>
        </form>
        <table className='table table-striped'>
          <thead>
            <th>Statistic</th>
            <th>Number</th>
          </thead>
          <Statistic
            name='Commercial projects'
            number={this.state.statistics.commercialProjectsNumber}/>
          <Statistic
            name='Internal projects'
            number={this.state.statistics.internalProjectsNumber}/>
          <Statistic
            name='Projects ending this month'
            number={this.state.statistics.projectsEndingThisMonthNumber}/>
          <Statistic
            name='Projects beginning next month'
            number={this.state.statistics.beginningNextMonthProjectsNumber}/>
        </table>
      </div>
    );
  }
}

export default Statistics;
