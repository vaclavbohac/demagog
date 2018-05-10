import * as React from 'react';

import Dropzone, { ImageFile } from 'react-dropzone';

interface IAvatarFormProps {
  onChange: (files: ImageFile[]) => void;
}

interface IAvatarFormState {
  files: ImageFile[];
}

// TODO: Rename to dropzone?
// TODO: Dropped file mime type validation validation (accept images only)
export class AvatarForm extends React.Component<IAvatarFormProps, IAvatarFormState> {
  constructor(props) {
    super(props);

    this.state = {
      files: [],
    };
  }

  public render() {
    return (
      <Dropzone
        className="avatar-form-dropzone"
        onDrop={(acceptedFiles) => {
          this.setState({
            files: acceptedFiles,
          });

          this.props.onChange(acceptedFiles);
        }}
      >
        {this.state.files.length ? (
          this.state.files.map((file) => (
            <img className="avatar-preview" key={file.name} src={file.preview} />
          ))
        ) : (
          <p>Zde přetáhněte fotku</p>
        )}
      </Dropzone>
    );
  }
}
