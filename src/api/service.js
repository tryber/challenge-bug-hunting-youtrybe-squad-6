let YOUTUBE_API_URL = 'https://www.googleapis.com/youtube/v3';

const YOUTUBE_AUTH_KEY = process.env.REACT_APP_API_KEY;

export const searchVideos = (searchText) => {
  const URL = `${YOUTUBE_API_URL}/search?part=snippet&q=${searchText}&type=video&maxResults=25&key=${YOUTUBE_AUTH_KEY}`;
  return new Promise((resolve, reject) => {
    fetch(URL)
      .then((data) => data.json())
      .then((result) => resolve(result))
      .catch(error => reject(error))
  });
};

export const getVideoInfo = (videoId) => {
  const urlParams = `part=snippet%2CcontentDetails%2Cstatistics&id=${videoId}&key=${YOUTUBE_AUTH_KEY}`;
  const URL = `${YOUTUBE_API_URL}/videos?${urlParams}`;
  return new Promise((resolve, reject) => {
    fetch(URL)
      .then((data) => data.json())
      .then((result) => resolve(result))
      .catch(error => reject(error))
  });
};

export const getVideoComments = (videoId) => {
  const urlParams = `part=snippet&videoId=${videoId}&textFormat=plainText&key=${YOUTUBE_AUTH_KEY}`;
  const URL = `${YOUTUBE_API_URL}/commentThreads?${urlParams}`;
  return new Promise((resolve, reject) => {
    fetch(URL)
      .then((data) => data.json())
      .then((result) => resolve(result))
      .catch(error => reject(error))
  });
};
