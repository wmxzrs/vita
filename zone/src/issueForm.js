mport React, { useState } from 'react';
import { createIssue } from './githubService';

const IssueForm = () => {
	  const [title, setTitle] = useState('');
	  const [body, setBody] = useState('');

	  const handleSubmit = async (e) => {
		      e.preventDefault();

		      try {
			            const response = await createIssue('YOUR_GITHUB_TOKEN', 'OWNER', 'REPO', title, body);
			            console.log('Issue created successfully:', response);
			            // Do something with the response, e.g., show a success message
			           } catch (error) {
			           // Handle error, e.g., show an error message
			                     }
			                       };
			      
			                         return (
			                             <form onSubmit={handleSubmit}>
			                                   <input type="text" value={title} onChange={(e) => setTitle(e.target.value)} placeholder="Issue Title" />
			                                         <textarea value={body} onChange={(e) => setBody(e.target.value)} placeholder="Issue Body"></textarea>
			                                               <button type="submit">Create Issue</button>
			                                                   </form>
			                                                     );
			                                                     };                                              export default IssueForm;
			             i                                        
