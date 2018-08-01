import * as React from 'react';

import { Colors } from '@blueprintjs/core';
import { Query } from 'react-apollo';
import Select, { Option } from 'react-select';

import { GetRolesQuery } from '../../../operation-result-types';
import { GetRoles } from '../../../queries/queries';

class GetRolesQueryComponent extends Query<GetRolesQuery> {}

interface IProps {
  className?: string;
  error?: object | false;
  id?: string;
  value: string | null;
  onChange(value: string): void;
  onBlur(): void;
}

export default class RoleSelect extends React.Component<IProps> {
  public render() {
    return (
      <GetRolesQueryComponent query={GetRoles}>
        {({ data, loading }) => {
          let options: Array<{ label: string; value: string }> = [];

          if (data && !loading) {
            options = data.roles.map((r) => ({
              label: r.name,
              value: r.id,
            }));
          }

          return (
            <Select
              id={this.props.id}
              value={this.props.value || undefined}
              isLoading={loading}
              options={options}
              onChange={(option: Option<string>) =>
                option.value && this.props.onChange(option.value)
              }
              onBlur={this.props.onBlur}
              placeholder="Vyberte…"
              clearable={false}
              style={{
                borderColor: this.props.error ? Colors.RED3 : '#cccccc',
              }}
            />
          );
        }}
      </GetRolesQueryComponent>
    );
  }
}
