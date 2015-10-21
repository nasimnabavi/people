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
        commercialProjects: [],
        internalProjects: [],
        projectsEndingThisMonth: [],
        beginningNextMonthProjects: [],
        billableDevelopers: [],
        developersInInternals: [],
        juniorsAndInterns: [],

      },
      date: (new Date).getFullYear() + '-' + ((new Date).getMonth() + 1),
      epochDate: ((new Date).getFullYear() - 1970) * 12 + (new Date).getMonth()
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
        <StatisticsSearch onFormSubmit={this.onFormSubmit} initDate={this.state.date} epochInitDate={this.state.epochDate}/>
        <h3>Projects</h3>
        <table className='table'>
          <thead>
            <th>Statistic</th>
            <th>Number</th>
          </thead>
          <Statistic
            name='Commercial projects'
            detailsArray={this.state.statistics.commercialProjects}/>
          <Statistic
            name='Internal projects'
            detailsArray={this.state.statistics.internalProjects}/>
          <Statistic
            name='Projects ending'
            detailsArray={this.state.statistics.projectsEndingThisMonth}/>
          <Statistic
            name='Projects beginning next month'
            detailsArray={this.state.statistics.beginningNextMonthProjects}/>
        </table>
        <h3>People</h3>
        <table className='table'>
          <thead>
            <th>Statistic</th>
            <th>Number</th>
          </thead>
          <Statistic
            name='Billable developers'
            detailsArray={this.state.statistics.billableDevelopers}/>
          <Statistic
            name='Developers in internals'
            detailsArray={this.state.statistics.developersInInternals}/>
          <Statistic
            name='Juniors and interns'
            detailsArray={this.state.statistics.juniorsAndInterns}/>
        </table>
      </div>
    );
  }
}

export default Statistics;
