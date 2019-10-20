export interface IVideo {
  getTime: () => number;
  goToTime: (time: number) => void;
}
