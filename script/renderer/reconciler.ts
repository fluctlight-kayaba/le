import type { ReactElement }	from 'react';
import createReconciler from 'react-reconciler';

const appendChildNode = () => {
	console.log('appending..')
};

export const reconciler = createReconciler({
	getRootHostContext: () => {
		return {
			isInsideText: false,
		};
	},
	getChildHostContext: () => {
		return {
			isInsideText: false,
		};
	},
	appendInitialChild: appendChildNode,
	appendChildToContainer: appendChildNode,
	finalizeInitialChildren: () => {
		return false;
	},
	shouldSetTextContent: () => false,
	createInstance: () => {},
	supportsMutation: true,
	appendChild: () => {},
	prepareForCommit: () => null,
	preparePortalMount: () => null, 
	clearContainer: () => false,
	resetAfterCommit: () => null,
	createTextInstance: () => {},
});
