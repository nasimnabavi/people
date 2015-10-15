import React from 'react'

class Detail extends React.Component {
  static get propTypes() {
    return {
      url: React.PropTypes.string.isRequired,
      name: React.PropTypes.string.isRequired,
    };
  }

  render() {
    return (
      <li><a href={this.props.url}>{this.props.name}</a></li>
    );
  }
}

export default Detail;
