import * as React from 'react';

import { ImageFile } from 'react-dropzone';
import { connect } from 'react-redux';
import { Dispatch } from 'redux';
import { AjaxRequest, Observable } from 'rxjs';

import { addFlashMessage } from '../../actions/flashMessages';
import { IState } from '../../reducers';
import { AvatarForm } from '../forms/AvatarForm';

export interface IImageUploadModalProps {
  speakerId: number;
  onClose(): void;
  addFlashMessage(message: string): void;
}

export interface IImageUploadModalState {
  files: ImageFile[];
  isSaving: boolean;
}

// TODO: Modal background
class ImageUploadModalPure extends React.Component<IImageUploadModalProps, IImageUploadModalState> {
  constructor(props: IImageUploadModalProps) {
    super(props);

    this.state = {
      files: [],
      isSaving: false,
    };
  }

  private closeImageUploadModal = (
    evt: React.MouseEvent<HTMLAnchorElement | HTMLButtonElement>,
  ) => {
    this.props.onClose();

    evt.preventDefault();
  };

  private onFormSubmit = (evt: React.MouseEvent<HTMLButtonElement>) => {
    this.setState({ isSaving: true });

    const formData = this.state.files.reduce((data, file) => {
      data.append('file', file);
      return data;
    }, new FormData());

    const request: AjaxRequest = {
      method: 'POST',
      url: '/admin/profile-picture/' + this.props.speakerId,
      body: formData,
    };

    Observable.ajax(request).subscribe(
      () => {
        this.setState({ isSaving: false });
        this.props.addFlashMessage('Fotka úspěšně uložena.');
        this.props.onClose();
      },
      () => {
        this.setState({ isSaving: false });
        this.props.addFlashMessage('Došlo k chybě při ukládání fotky.');
      },
    );

    evt.preventDefault();
  };

  // tslint:disable-next-line:member-ordering
  public render() {
    return (
      <div className="modal image-upload" tabIndex={-1} role="dialog" style={{ display: 'block' }}>
        <div className="modal-dialog" role="document">
          <div className="modal-content">
            <div className="modal-header">
              <h5 className="modal-title">Upravit fotku</h5>
              <button
                onClick={this.closeImageUploadModal}
                type="button"
                className="close"
                data-dismiss="modal"
                aria-label="Close"
              >
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div className="modal-body">
              <AvatarForm onChange={(files) => this.setState({ files })} />
            </div>
            <div className="modal-footer">
              <button
                disabled={this.state.isSaving}
                type="button"
                className="btn btn-primary"
                onClick={this.onFormSubmit}
              >
                {this.state.isSaving ? 'Saving...' : 'Save changes'}
              </button>
              <button
                onClick={this.closeImageUploadModal}
                type="button"
                className="btn btn-secondary"
                data-dismiss="modal"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

function mapDispatchToProps(dispatch: Dispatch<IState>) {
  return {
    addFlashMessage(message: string) {
      dispatch(addFlashMessage(message));
    },
  };
}

export const ImageUploadModal = connect(null, mapDispatchToProps)(ImageUploadModalPure);
