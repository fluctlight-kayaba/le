import type { FC }	from 'react';
import { useEffect, useRef }  from 'react';

import { render }	from './fiber';

const App: FC = () => {
	const counterRef = useRef<number>(0); 

  useEffect(() => {
    console.log(counterRef.current, '<-- counterRef');
  }, []);

	return <div>
		<h1>hmm</h1>
	</div>
}

render(<App />, null);
