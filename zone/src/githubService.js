import axios from 'axios';

const BASE_URL = 'https://api.github.com';

export const createIssue = async (token, owner, repo, title, body) => {
	  const url = `${BASE_URL}/repos/${owner}/${repo}/issues`;
	  const headers = {
		      Authorization: `token ${token}`,
		    };
	  const data = {
		      title,
		      body,
		    };

	  try {
		      const response = await axios.post(url, data, { headers });
		      return response.data;
		    } catch (error) {
			        console.error('Failed to create issue:', error);
			        throw error;
			      }
};

