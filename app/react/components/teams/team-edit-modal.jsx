import React, {PropTypes} from 'react';
import TeamActions from '../../actions/TeamActions';
import Modal from 'react-modal';


export default class TeamEditModal extends React.Component {
  constructor(props) {
    super(props);
    this.removeTeam = this.removeTeam.bind(this);
    this.updateTeam = this.updateTeam.bind(this);
  }

  removeTeam() {
    TeamActions.delete(this.props.editedTeam.id);
  }

  updateTeam() {
    TeamActions.update({ editedTeam: this.props.editedTeam, name: this.state.newTeamName });
  }

  render() {
    const updateNewTeamName = (e) => this.setState({ newTeamName: e.target.value });
    Modal.setAppElement('#teams-region');
    const modalStyles = {
      content : {
        top                   : '20%',
        left                  : '50%',
        right                 : 'auto',
        bottom                : 'auto',
        marginRight           : '-50%',
        transform             : 'translate(-50%, -50%)'
      }
    };
    return(
      <Modal
        className="Modal__Bootstrap modal-dialog"
        closeTimeoutMS={150}
        isOpen={true}
        onRequestClose={this.props.closeModalCallback}
        style={modalStyles}>
        <div className="modal-header">
          <button type="button" className="close" onClick={this.props.closeModalCallback}>
            <span aria-hidden="true">&times;</span>
            <span className="sr-only">Close</span>
          </button>
          <h4 className="modal-title">Edit team</h4>
        </div>
        <div className="modal-body">
          <h4>New name: </h4>
          <input type="text" onChange={updateNewTeamName}></input>
        </div>
        <div className="modal-footer">
          <button type="button" className="btn btn-danger" onClick={this.removeTeam}>Remove</button>
          <button type="button" className="btn btn-default" onClick={this.props.closeModalCallback}>Close</button>
          <button type="button" className="btn btn-primary" onClick={this.updateTeam}>Save changes</button>
        </div>
      </Modal>
    );
  }
}

TeamEditModal.propTypes = {
  editedTeam: PropTypes.object.isRequired,
  closeModalCallback: PropTypes.func.isRequired
};
