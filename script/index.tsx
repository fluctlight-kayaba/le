import { render }	from './renderer';
// import type { FC }	from 'react';
// import { useRef }  from 'react';
// log(konsole.log)
//
console.log = log as never;

// const add = (a: number, b: number) => {
//   return a + b;
// };

// for (let i = 0; i < 5; i ++) {
// 	console.log(i);
// }

const App: FC = () => {
	const ref = useRef<number>(0); 

	return <div>
		<h1>hmm</h1>
	</div>
}

console.log(render(App, null));

// console.log(JSON.stringify(<App />));
// add(10, 12);
