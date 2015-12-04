import React, {PropTypes} from 'react';
import Note from './note';
import NewNoteForm from './new-note-form';

export default class Notes extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      notes: props.notes
    };

    this.changeNoteCallback = this.changeNoteCallback.bind(this);
    this.noteAddedCallback = this.noteAddedCallback.bind(this);
    this.noteRemovedCallback = this.noteRemovedCallback.bind(this);
  }

  changeNoteCallback(note) {
    let notes = this.state.notes;
    const notesIds = notes.map((note) => note.id);
    const indexOfNote = notesIds.indexOf(note.id);
    notes[indexOfNote] = note;
    this.setState({ notes: notes });
  }

  noteAddedCallback(note) {
    const notes = this.state.notes;
    notes.push(note);
    this.setState({ notes: notes });
  }

  noteRemovedCallback(noteId) {
    let notes = this.state.notes;
    const notesIds = notes.map((note) => note.id);
    const indexOfNote = notesIds.indexOf(noteId);
    notes.splice(indexOfNote, 1);
    this.setState({ notes: notes });
  }

  render() {
    const notesViews = this.props.notes.map((note) => {
      return <Note key={note.id}
        note={note}
        changeNoteCallback={this.changeNoteCallback}
        noteRemovedCallback={this.noteRemovedCallback}/>
    });
    return(
      <div>
        <div className="project-notes-wrapper">
          <div className="project-notes-block">
            <div className="project-notes-region">
              {notesViews}
            </div>
          </div>
        </div>
        <NewNoteForm projectId={this.props.projectId}
          noteAddedCallback={this.noteAddedCallback} />
      </div>
    );
  }
}

Notes.propTypes = {
  notes: PropTypes.array.isRequired,
  projectId: PropTypes.number.isRequired
};
