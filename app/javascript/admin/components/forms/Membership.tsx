import * as React from 'react';

import { Query } from 'react-apollo';
import Loading from '../Loading';

import { GetSpeakerBodiesQuery } from '../../operation-result-types';
import { GetSpeakersBodies } from '../../queries/queries';

import * as GO from 'react-icons/lib/go';

class SpeakerQueryComponent extends Query<GetSpeakerBodiesQuery> {}

interface IMembershipProps {
  body?: number;
  since?: string;
  until?: string;

  onChange?(membership: IMembershipState): void;
  onRemove?(evt: React.MouseEvent<React.ReactSVGElement>): void;
}

interface IMembershipState {
  body?: number;
  since?: string;
  until?: string;
}

export class Membership extends React.Component<IMembershipProps, IMembershipState> {
  constructor(props: IMembershipProps) {
    super(props);

    this.state = {
      body: props.body,
      since: props.since,
      until: props.until,
    };
  }

  private onChange = (change: Partial<IMembershipState>) => {
    this.setState(change, () => {
      if (this.props.onChange) {
        this.props.onChange(this.state);
      }
    });
  };

  private onBodyChange = (evt: React.ChangeEvent<HTMLSelectElement>) => {
    this.onChange({ body: parseInt(evt.target.value, 10) });
  };

  private onDateChange = (name: string) => (evt: React.ChangeEvent<HTMLInputElement>) => {
    this.onChange({ [name]: evt.target.value });
  };

  // tslint:disable-next-line:member-ordering
  public render() {
    return (
      <div className="form-row">
        <div className="form-group col-md-5">
          <label htmlFor="illustration">Příslušnost ke skupině:</label>

          <SpeakerQueryComponent query={GetSpeakersBodies}>
            {({ data, loading }) => {
              if (loading) {
                return <Loading />;
              }

              if (!data) {
                return null;
              }

              return (
                <select name="body" className="custom-select" onChange={this.onBodyChange}>
                  {data.bodies.map((party) => (
                    <option key={party.id} value={party.id}>
                      {party.name}
                    </option>
                  ))}
                </select>
              );
            }}
          </SpeakerQueryComponent>
        </div>

        <div className="form-group col-md-3">
          <label htmlFor="since">Od:</label>
          <input
            type="date"
            className="form-control"
            id="since"
            placeholder="Zadejte datum"
            onChange={this.onDateChange('since')}
          />
        </div>

        <div className="form-group col-md-3">
          <label htmlFor="until">Do:</label>
          <input
            type="date"
            className="form-control"
            id="until"
            placeholder="Zadejte datum"
            onChange={this.onDateChange('until')}
          />
        </div>

        <div className="form-group col-md-1">
          <br />
          <GO.GoTrashcan style={{ cursor: 'pointer' }} onClick={this.props.onRemove} />
        </div>
      </div>
    );
  }
}
