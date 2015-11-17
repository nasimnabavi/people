import React, {PropTypes} from 'react';
import StatisticsPeopleRow from './statistics-people-row';

export default class StatisticsPeople extends React.Component {
  render() {
    let supportDevelopers = this.props.statistics.supportDevelopers;
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
            <StatisticsPeopleRow
              label={"Designers/UX"}
              interns={[]}
              juniors={[]}
              regulars={this.props.statistics.designers}
              seniors={this.props.statistics.seniorDesigners} />
            <StatisticsPeopleRow
              label={"PMs"}
              interns={[]}
              juniors={this.props.statistics.juniorProjectManagers}
              regulars={this.props.statistics.projectManagers}
              seniors={this.props.statistics.seniorProjectManagers} />
            <StatisticsPeopleRow
              label={"QAs"}
              interns={[]}
              juniors={this.props.statistics.juniorQualityAssurance}
              regulars={this.props.statistics.qualityAssurance}
              seniors={this.props.statistics.seniorQualityAssurance} />
            <tr>
              <td>Support</td>
              <td className="text-center" colSpan="5">
                {supportDevelopers ? supportDevelopers.length : 0}
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    );
  }
}

StatisticsPeople.propTypes = {
  statistics: PropTypes.object.isRequired
};
