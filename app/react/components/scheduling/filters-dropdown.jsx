import React, {PropTypes} from 'react';
import Select from 'react-select';

export default class FiltersDropdown extends React.Component {
  static get propTypes() {
    return {
      className: React.PropTypes.string.isRequired,
      store_objects: React.PropTypes.array.isRequired,
      filter_store_ids: React.PropTypes.array.isRequired,
      changeFilterAction: React.PropTypes.func.isRequired
    };
  }

  constructor(props) {
    super(props);
    this.handleFilterChange = this.handleFilterChange.bind(this);
  }

  handleFilterChange(values) {
    let objectIds = [];
    if(values != '') {
      objectIds = values.split(',').map(value => Number(value));
    }
    this.props.changeFilterAction(objectIds);
  }

  render() {
    const className = this.props.className;
    const store_objects = this.props.store_objects;
    const filter_store_ids = this.props.filter_store_ids;

    const filterOptions = store_objects.map(obj => {
      return { label: obj.name, value: obj.id };
    });

    const selectValue = filter_store_ids.map(objId => {
      const optionIds = filterOptions.map(option => option.value);
      let optionIndex = optionIds.indexOf(objId);
      return filterOptions[optionIndex];
    });

    return(
      <div className={className + " filter"}>
        <Select
              name={"filter-" + className}
              placeholder={"Filter " + className + "..."}
              multi={true}
              value={selectValue}
              options={filterOptions}
              onChange={this.handleFilterChange} />
      </div>
    );
  }
}
