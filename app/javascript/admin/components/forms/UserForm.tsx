/* eslint camelcase: 0, react/sort-comp: 0 */

import * as React from 'react';
import { Link } from 'react-router-dom';

import { GetUserQuery, UserInputType } from '../../operation-result-types';
import SpeakerAvatar from '../SpeakerAvatar';
import ImageInput, { ImageValueType } from './controls/ImageInput';
import RoleSelect from './controls/RoleSelect';
import { Form } from './Form';

export interface IUserFormData extends UserInputType {
  avatar: ImageValueType;
}

interface IUserFormProps {
  userQuery?: GetUserQuery;
  onSubmit: (formData: IUserFormData) => void;
  submitting: boolean;
  title: string;
}

class UserFormInternal extends Form<IUserFormData> {}

// tslint:disable-next-line:max-classes-per-file
export class UserForm extends React.Component<IUserFormProps> {
  public static defaultProps = {
    userQuery: {
      user: {
        id: '',

        active: false,
        email: '',
        first_name: '',
        last_name: '',
        avatar: null,
        bio: '',
        role: {
          id: null,
        },
      },
    },
  };

  // tslint:disable-next-line:member-ordering
  public render() {
    const { userQuery, submitting, title } = this.props;

    if (!userQuery) {
      return null;
    }

    const defaultValues = {
      active: userQuery.user.active,
      email: userQuery.user.email,
      first_name: userQuery.user.first_name,
      last_name: userQuery.user.last_name,
      avatar: userQuery.user.avatar,
      bio: userQuery.user.bio,
      role_id: userQuery.user.role.id,
    };

    return (
      <UserFormInternal defaultValues={defaultValues} onSubmit={this.props.onSubmit}>
        {({ onAssociationChange, onInputChange, onCheckboxChange, onImageChange }, data) => (
          <div style={{ paddingBottom: 50 }}>
            <div className="float-right">
              <Link to="/admin/users" className="btn btn-secondary">
                Zpět
              </Link>
              <button
                type="submit"
                className="btn btn-primary"
                style={{ marginLeft: 7 }}
                disabled={submitting}
              >
                {submitting ? 'Ukládám ...' : 'Uložit'}
              </button>
            </div>

            <h3 style={{ marginBottom: 25 }}>{title}</h3>

            <div className="form-row">
              <div className="form-group col-md-6">
                <label htmlFor="first_name">Jméno:</label>
                <input
                  className="form-control"
                  id="first_name"
                  placeholder="Zadejte jméno"
                  defaultValue={userQuery.user.first_name || ''}
                  onChange={onInputChange('first_name')}
                />
              </div>

              <div className="form-group col-md-6">
                <label htmlFor="last_name">Přijmení</label>
                <input
                  className="form-control"
                  id="last_name"
                  placeholder="Zadejte přijmení"
                  defaultValue={userQuery.user.last_name || ''}
                  onChange={onInputChange('last_name')}
                />
              </div>
            </div>

            <div className="form-row">
              <div className="form-group col-md-6">
                <label htmlFor="email">E-mail:</label>
                <input
                  required
                  className="form-control"
                  id="email"
                  placeholder="Zadejte jméno"
                  defaultValue={userQuery.user.email || ''}
                  onChange={onInputChange('email')}
                />
              </div>
            </div>

            <div className="form-row">
              <div className="form-group col-md-3">
                <div className="form-check">
                  <input
                    className="form-check-input"
                    type="checkbox"
                    onChange={onCheckboxChange('active')}
                    defaultChecked={userQuery.user.active}
                    id="active"
                  />
                  <label className="form-check-label" htmlFor="active">
                    Uživatel je aktivní
                  </label>
                </div>
              </div>
            </div>

            <div className="form-row">
              <RoleSelect
                className="col-md-6"
                value={data.role_id || null}
                onChange={onAssociationChange('role_id')}
              />
            </div>

            <div className="form-row">
              <div className="form-group col-md-12">
                <ImageInput
                  label="Portrét"
                  name="avatar"
                  defaultValue={userQuery.user.avatar}
                  onChange={onImageChange('avatar')}
                  renderImage={(src) => <SpeakerAvatar avatar={src} />}
                />
              </div>
            </div>

            <div className="form-group">
              <label htmlFor="bio">Bio:</label>
              <textarea
                className="form-control"
                id="bio"
                rows={3}
                onChange={onInputChange('bio')}
                defaultValue={userQuery.user.bio || ''}
              />
            </div>

            <div className="form-group">
              <label htmlFor="bio">Popis pozice:</label>
              <textarea
                className="form-control"
                id="position_description"
                rows={3}
                onChange={onInputChange('position_description')}
                defaultValue={userQuery.user.position_description || ''}
              />
            </div>
          </div>
        )}
      </UserFormInternal>
    );
  }
}
