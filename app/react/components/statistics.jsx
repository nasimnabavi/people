import React from 'react';
import Statistic from './statistic'
import StatisticsSearch from './statistics-search'

class Statistics extends React.Component {
  static get propTypes() {
    return {
      token: React.PropTypes.string.isRequired,
      startDate: React.PropTypes.string.isRequired,
      endDate: React.PropTypes.string.isRequired
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
      }
    };
    this.onFormSubmit = this.onFormSubmit.bind(this);
    this.onFetchDataDone = this.onFetchDataDone.bind(this);
  }

  componentDidMount() {
    this.fetchStatistics(this.props.startDate, this.props.endDate)
  }

  fetchStatistics(startDate, endDate) {
    $.ajax({
      url: Routes.api_v2_statistics_path(),
      dataType: 'json',
      data: {
        startDate: startDate,
        endDate: endDate,
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

  onFormSubmit(startDate, endDate) {
    this.fetchStatistics(startDate, endDate);
  }

  render() {
    return (
      <div>
        <StatisticsSearch onFormSubmit={this.onFormSubmit} format='YYYY-MM-DD'
          initStartDate={this.props.startDate} initEndDate={this.props.endDate}/>
        <h3>Projects</h3>
        <table className='table'>
          <thead>
            <tr>
              <th>Statistic</th>
              <th>Number</th>
            </tr>
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
            <tr>
              <th>Statistic</th>
              <th>Number</th>
            </tr>
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
