import React, {PropTypes} from 'react';
import ProjectName from './project-name';
import Membership from './membership';
import AddUserToProject from './add-user-to-project';
import MembershipStore from '../../stores/MembershipStore';
import ProjectStore from '../../stores/ProjectStore';
import FilterStore from '../../stores/FilterStore';
import Notes from '../notes/notes';
import moment from 'moment';

export default class Project extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      project: props.project,
      membershipsChanges: 0,
      displayNotes: false,
      highlightEnding: false,
      showNext: false,
      highlightNotBillable: false
    };
    this._membershipsChanged = this._membershipsChanged.bind(this);
    this._filtersChanged = this._filtersChanged.bind(this);
  }

  componentDidMount() {
    MembershipStore.listen(this._membershipsChanged);
    FilterStore.listen(this._filtersChanged);
  }

  componentWillUnmount() {
    MembershipStore.unlisten(this._membershipsChanged);
    FilterStore.unlisten(this._filtersChanged);
  }

  _membershipsChanged() {
    this.setState({ membershipsChanges: (this.state.membershipsChanges + 1) });
  }

  _filtersChanged(store) {
    this.setState({
      highlightEnding: store.highlightEnding,
      showNext: store.showNext,
      highlightNotBillable: store.highlightNotBillable
    });
  }

  render() {
    const billableMemberships = MembershipStore.billableMemberships(this.state.project.id);
    const nonBillableMemberships = MembershipStore.nonBillableMemberships(this.state.project.id);

    const billableMembershipsRows = billableMemberships
      .map(membership => <Membership key={membership.id} membership={membership} />);
    const nonBillableMembershipsRows = nonBillableMemberships
      .map(membership => <Membership key={membership.id} membership={membership} />);

    const notes = ProjectStore.getNotesForProject(this.state.project.id);
    const toggleNotes = () => {
      this.setState({ displayNotes: !this.state.displayNotes });
    }

    const nonBillableSection = (
      <div>
        <div className="count">
          {nonBillableMemberships.length}
        </div>
        <div className="non-billable-list">
          <div>
            <div className="js-project-memberships memberships">
              {nonBillableMembershipsRows}
            </div>
          </div>
        </div>
      </div>
    );

    let adminSection = null;

    if(!this.props.project.archived) {
      adminSection = (
        <div className="admin-section">
          <AddUserToProject project={this.props.project} />
        </div>
      )
    };

    let rootClasses = "project";
    if(this.state.highlightEnding && this.state.project.end_at) {
      let endAt = moment(this.state.project.end_at);
      const projectEndingLengthInDays = 30;
      endAt.add(projectEndingLengthInDays, 'days');
      if(endAt > moment().add(projectEndingLengthInDays, 'days')) {
        rootClasses += " left";
      }
    }

    return(
        <div className={rootClasses}>
          <div className="row">
            <ProjectName project={this.state.project} toggleNotesCallback={toggleNotes} />
            <div className="col-md-9">
              <div className="project-details">
                <div className="js-memberships-region">
                  <div>
                    <div className="billable">
                      <div className="count">
                        {billableMemberships.length}
                      </div>
                      { adminSection }
                      <div className="billable-list">
                        <div>
                          <div className="js-project-memberships memberships">
                            {billableMembershipsRows}
                          </div>
                        </div>
                      </div>
                    </div>
                    <div className="non-billable">
                      { nonBillableMemberships.length > 0 ? nonBillableSection : null }
                    </div>
                  </div>
                </div>
              <div className="js-notes-region">
                { this.state.displayNotes ?
                <Notes notes={notes}
                  projectId={this.state.project.id} /> : null }
              </div>
            </div>
          </div>
      </div>
    </div>
    );
  }
}

Project.propTypes = {
  project: PropTypes.object.isRequired
};
