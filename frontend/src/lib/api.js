import axios from "axios";

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL;

export const api = axios.create({
  baseURL: `${BACKEND_URL}/api`,
  withCredentials: true,
  headers: {
    "Content-Type": "application/json",
  },
});

export const getData = async (path) => {
  const response = await api.get(path);
  return response.data;
};

export const postData = async (path, payload = {}) => {
  const response = await api.post(path, payload);
  return response.data;
};

export const patchData = async (path, payload = {}) => {
  const response = await api.patch(path, payload);
  return response.data;
};

export const putData = async (path, payload = {}) => {
  const response = await api.put(path, payload);
  return response.data;
};
