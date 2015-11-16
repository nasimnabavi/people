import React, {PropTypes} from 'react';
import StatisticsPeopleRow from './statistics-people-row';

export default class StatisticsPeople extends React.Component {
  render() {
    return(
      <div>
        <h3>Positions</h3>
        <table className='table'>
          <thead>
            <tr>
              <th>Technology/Role</th>
              <th>Interns</th>
              <th>Juniors</th>
              <th>Regular</th>
              <th>Senior</th>
              <th>Sum</th>
            </tr>
          </thead>
          <tbody>
            <StatisticsPeopleRow
              label={"Ruby on Rails"}
              interns={this.props.statistics.interns}
              juniors={this.props.statistics.juniorRor}
              regulars={this.props.statistics.rorDevs}
              seniors={this.props.statistics.seniorRorDevs} />
            <StatisticsPeopleRow
              label={"iOS"}
              interns={[]}
              juniors={this.props.statistics.juniorIos}
              regulars={this.props.statistics.iosDevs}
              seniors={this.props.statistics.seniorIosDevs} />
            <StatisticsPeopleRow
              label={"Android"}
              interns={[]}
              juniors={this.props.statistics.juniorAndroid}
              regulars={this.props.statistics.androidDevs}
              seniors={this.props.statistics.seniorAndroidDevs} />
            <StatisticsPeopleRow
              label={"Frontend"}
              interns={[]}
              juniors={this.props.statistics.juniorFrontend}
              regulars={this.props.statistics.frontendDevs}
              seniors={this.props.statistics.seniorFrontendDevs} />
          </tbody>
        </table>
      </div>
    );
  }
}

StatisticsPeople.propTypes = {
  statistics: PropTypes.array.required
};
