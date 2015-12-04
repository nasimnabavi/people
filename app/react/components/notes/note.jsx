import React, {PropTypes} from 'react';

export default class Note extends React.Component {
  constructor(props) {
    super(props);
    this.toggleNoteState = this.toggleNoteState.bind(this);
    this.removeNote = this.removeNote.bind(this);
  }

  removeNote() {
    const deletedSuccessfully = () => {
      let noteId = this.props.note.id;
      this.props.noteRemovedCallback(noteId);
    };
    const failedToUpdate = () => {
      debugger;
    };
    $.ajax({
      url: Routes.note_path(this.props.note.id),
      type: "DELETE",
      dataType: 'json',
    }).done(deletedSuccessfully).fail(failedToUpdate);
  }

  toggleNoteState() {
    const updatedSuccessfully = (data) => {
      let note = this.props.note;
      note.open = !note.open;
      this.props.changeNoteCallback(note);
    };
    const failedToUpdate = () => {
      debugger;
    };
    $.ajax({
      url: Routes.note_path(this.props.note.id),
      type: "PUT",
      dataType: 'json',
      data: {
        note: {
          open: !this.props.note.open
        }
      }
    }).done(updatedSuccessfully).fail(failedToUpdate);
  }

  render() {
    const noteGlyphicon = this.props.note.open ? 'glyphicon-ok' : 'glyphicon-play';
    const closedClasses = this.props.note.open ? 'closed-note hidden' : 'closed-note';

    return(
      <div className='project-note'>
        <img className='note-img img-circle' />
        <div className='note-group'>
          <div className={closedClasses}>closed</div>
          <div className='note-text'>{this.props.note.text}</div>
        </div>
        <span className='glyphicon glyphicon-trash note-remove' onClick={this.removeNote} />
        <span className={'glyphicon note-close ' + noteGlyphicon} onClick={this.toggleNoteState} />
      </div>
    );
  }
}

Note.propTypes = {
  note: PropTypes.object.isRequired,
  changeNoteCallback: PropTypes.func.isRequired,
  noteRemovedCallback: PropTypes.func.isRequired
};
