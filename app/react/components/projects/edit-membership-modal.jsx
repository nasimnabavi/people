import React, {PropTypes} from 'react';
import SelectedMembershipStore from '../../stores/SelectedMembershipStore';
import SelectedMembershipActions from '../../actions/SelectedMembershipActions';
import MembershipActions from '../../actions/MembershipActions';
import Modal from 'react-modal';
import DayPicker from "react-day-picker";
import Moment from 'moment';

import "react-day-picker/lib/style.css";

export default class EditMembershipModal extends React.Component {
  constructor(props) {
    super(props);
    const membership = SelectedMembershipStore.getState().membership;
    const billable = membership ? membership.billable : true;
    const startDate = membership ? membership.starts_at : Moment().format("YYYY-MM-DD");
    const endDate = (membership && membership.ends_at) ? membership.ends_at : null;
    this.state = {
      membership: membership,
      startDate: startDate,
      endDate: endDate,
      billable: billable
    };
    this._showEditMembershipModal = this._showEditMembershipModal.bind(this);
  }

  componentDidMount() {
    SelectedMembershipStore.listen(this._showEditMembershipModal);
  }

  componentWillUnmount() {
    SelectedMembershipStore.unlisten(this._showEditMembershipModal);
  }

  _showEditMembershipModal(storeState) {
    if(storeState.membership == null) {
      this.setState({ membership: null });
    } else {
      const endsAt = storeState.membership.ends_at ? Moment(storeState.membership.ends_at).format("YYYY-MM-DD") : null;
      this.setState({
        membership: storeState.membership,
        startDate: Moment(storeState.membership.starts_at).format("YYYY-MM-DD"),
        endDate: endsAt,
        billable: storeState.membership.billable
      });
    }
  }

  render() {
    if(this.state.membership == null) {
      return null;
    }

    const membership = this.state.membership;

    Modal.setAppElement('body');
    const modalStyles = {
      content : {
        top                   : '20%',
        left                  : '50%',
        right                 : 'auto',
        bottom                : 'auto',
        marginRight           : '-50%',
      }
    };

    const editMembership = () => {
      const params = {
        id: this.state.membership.id,
        billable: this.state.billable,
        booked: this.state.booked,
        starts_at: this.state.startDate,
        ends_at: this.state.endDate
      };
      MembershipActions.update(params);
      SelectedMembershipActions.cancelEditMembership();
    };
    const closeModal = () => SelectedMembershipActions.cancelEditMembership();

    const handleStartDateChange = (e, day, modifiers) => {
      const date = Moment(day).format("YYYY-MM-DD");
      $('#startDate').val(date);
      this.setState({ showStartDate: false, startDate: date });
    };
    const handleEndDateChange = (e, day, modifiers) => {
      const date = Moment(day).format("YYYY-MM-DD");
      $('#endDate').val(date);
      this.setState({ showEndDate: false, endDate: date });
    };

    const startDateValue = this.state.membership.starts_at;
    const endDateValue = this.state.membership.ends_at;

    const showStartDatePicker = () => this.setState({ showStartDate: true, showEndDate: false });
    const showEndDatePicker = () => this.setState({ showStartDate: false, showEndDate: true });
    const changeBillable = () => this.setState({ billable: !this.state.billable });
    const changeBooked = () => this.setState({ booked: !this.state.booked });

    return(
      <Modal
        className="Modal__Bootstrap modal-dialog"
        closeTimeoutMS={150}
        isOpen={this.state.membership != null}
        onRequestClose={closeModal}
        style={modalStyles}>
        <div className="modal-header">
          <button type="button" className="close" onClick={closeModal}>
            <span aria-hidden="true">&times;</span>
            <span className="sr-only">Close</span>
          </button>
          <h4 className="modal-title">Edit membership</h4>
        </div>
        <div className="modal-body">
          <div className="form-group date">
            <div className="input-group">
              <label>
                <abbr title="required">*From:</abbr>
              </label>
              <input id="startDate" type="text" onClick={showStartDatePicker}
                defaultValue={startDateValue}></input>
            </div>
          </div>
          <div className="form-group date">
            <div className="input-group">
              <label>
                <abbr title="required">To:</abbr>
              </label>
              <input id="endDate" type="text" onClick={showEndDatePicker}
                defaultValue={endDateValue}></input>
            </div>
          </div>
          { this.state.showStartDate ?
            <DayPicker
              onDayClick={handleStartDateChange} /> : null }
          { this.state.showEndDate ?
            <DayPicker
              onDayClick={handleEndDateChange} /> : null }
          <div>
            <input id="isBillable" type="checkbox"
              defaultChecked={this.state.membership.billable}
              onClick={changeBillable}></input>
            <label>Billable</label>
          </div>
          <div>
            <input id="isBooked" type="checkbox"
              defaultChecked={this.state.membership.booked}
              onClick={changeBooked}></input>
            <label>Booked</label>
          </div>
        </div>
        <div className="modal-footer">
          <button type="button" className="btn btn-default" onClick={closeModal}>Close</button>
          <button type="button" className="btn btn-primary" onClick={editMembership}>Save changes</button>
        </div>
      </Modal>
    );
  }
}
