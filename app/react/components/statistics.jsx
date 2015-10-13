import React from 'react';
import Statistic from './statistic'
import StatisticsSearch from './statistics-search'

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
    this.onFormSubmit = this.onFormSubmit.bind(this);
    this.onFetchDataDone = this.onFetchDataDone.bind(this);
  }

  componentDidMount() {
    this.fetchStatistics(this.state.date)
  }

  fetchStatistics(date) {
    $.ajax({
      url: Routes.api_v2_statistics_path(),
      dataType: 'json',
      data: {
        date: date,
        token: this.props.token
      }
    }).done(this.onFetchDataDone).fail(this.onFetchDataFail);
  }

  onFetchDataDone(data, textStatus, jqXHR) {
    this.setState({statistics: data});
  }

  onFetchDataFail(xhr, status, err) {
    console.error(Routes.api_v2_statistics_path(), status, err.toString());
  }

  onFormSubmit(date) {
    this.fetchStatistics(date);
  }

  render() {
    return (
      <div>
        <StatisticsSearch onFormSubmit={this.onFormSubmit} initDate={this.state.date}/>
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
