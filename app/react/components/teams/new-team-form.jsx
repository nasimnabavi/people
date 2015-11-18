import React, {PropTypes} from 'react';
import TeamActions from '../../actions/TeamActions';

export default class NewTeamForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      display: false,
      newTeamName: ''
    };
    this.newTeamRow = this.newTeamRow.bind(this);
  }

  newTeamRow() {
    const handleTeamChangeName = (e) => this.setState({ teamName: e.target.value });
    const createTeam = () => {
      TeamActions.create(this.state.teamName);
      this.setState({ display: false });
    }
    const closeNewTeamRow = () => this.setState({ display: false });
    return (
      <div className="js-new-team-form sm-bottom-margin">
        <div className="form-group">
          <div className="input-group">
            <label className="control-label">
              <abbr title="required"></abbr>
            </label>
            <input className="form-control name" placeholder="Team name..." type="text" onChange={handleTeamChangeName}>
            </input>
          </div>
        </div>
        <div className="actions">
          <a className="btn btn-danger btn-sm new-team-close" href="#" onClick={closeNewTeamRow}>Close</a>
          <a className="btn btn-default btn-sm new-team-submit" href="#" onClick={createTeam}>Add team</a>
        </div>
      </div>
    );
  }

  render() {
    const onNewTeamButtonClick = () => this.setState({ display: true });
    return(
      <div className="row">
        <div className="col-md-12" id="buttons-region">
          <div className="btn btn-success new-team-add xs-bottom-margin" onClick={onNewTeamButtonClick}>
            <div className="glyphicon glyphicon-plus pull-left"></div>
            <div className="pull-right small">New team</div>
          </div>
          { this.state.display ? this.newTeamRow() : null}
        </div>
      </div>
    );
  }
}
