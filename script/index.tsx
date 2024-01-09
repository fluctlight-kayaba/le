import { openInEditor } from 'bun';
import type { FC }	from 'react';
import { useRef }  from 'react';
print('hello world!!!');

const add = (a: number, b: number) => {
  return a + b;
};

for (let i = 0; i < 5; i ++) {
	print(i);
}

const App: FC = () => {
	const ref = useRef<number>(0); 
	print(ref + '<--');

	return <div>
		<h1>hmm</h1>
	</div>
}

print(JSON.stringify(<App />));
add(10, 10);
