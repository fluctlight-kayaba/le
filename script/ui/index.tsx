import type { FC } from 'react';

const Text = (props) => {
  return <p className={props.className}>{props.content}</p>
}

export const Editor: FC = () => {
  return (
    <div>
      <Text className="hello-class" content="Hello" />
      <span style={{ color: 'blue' }}>World</span>
    </div>
  );
};

export default Editor;
