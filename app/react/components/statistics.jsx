import React from 'react';

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
          <tr>
            <td>Commercial projects</td>
            <td>{this.state.statistics.commercialProjectsNumber}</td>
          </tr>
          <tr>
            <td>Internal projects</td>
            <td>{this.state.statistics.internalProjectsNumber}</td>
          </tr>
          <tr>
            <td>Projects ending this month</td>
            <td>{this.state.statistics.projectsEndingThisMonthNumber}</td>
          </tr>
          <tr>
            <td>Projects beginning next month</td>
            <td>{this.state.statistics.beginningNextMonthProjectsNumber}</td>
          </tr>
        </table>
      </div>
    );
  }
}

export default Statistics;
