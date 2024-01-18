import type { ReactElement }	from 'react';

import { reconciler }	from './reconciler';

export const render = (element: ReactElement, rootContainer, callback?: () => void) => {
	const container = reconciler.createContainer(rootContainer, 0, null, false, null, 'id', () => {}, null);

	const parentComponent = null;
	reconciler.updateContainer(element, container, parentComponent, callback);
};
