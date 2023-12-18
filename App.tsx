import React, { useState, useEffect } from 'react';
import { View, StyleSheet, Dimensions } from 'react-native';

const { width, height } = Dimensions.get('window');
const numBubbles = 50;

interface Bobble {
  position: { x: number; y: number };
  color: string;
  speed: number;
  theta: number;
  radius: number;
}

const getRandomColor = (): string => {
  const a = Math.floor(Math.random() * 200);
  return `rgba(255, 255, 255, ${a / 255})`;
};

const calculateXY = (speed: number, theta: number): { x: number; y: number } => {
  return { x: speed * Math.cos(theta), y: speed * Math.sin(theta) };
};

const App: React.FC = () => {
  const [bubbles, setBubbles] = useState<Bobble[]>([]);

  useEffect(() => {
    const createBubbles = () => {
      const newBubbles: Bobble[] = [];
      for (let i = 0; i < numBubbles; i++) {
        const bubble: Bobble = {
          position: { x: Math.random() * width, y: Math.random() * height },
          color: getRandomColor(),
          speed: Math.random(),
          radius: Math.random() * 100,
          theta: Math.random() * (2 * Math.PI),
        };
        newBubbles.push(bubble);
      }
      setBubbles(newBubbles);
    };

    createBubbles();

    const intervalId = setInterval(() => {
      setBubbles((prevBubbles) =>
        prevBubbles.map((bubble) => {
          const { x, y } = calculateXY(bubble.speed, bubble.theta);
          let dx = x + bubble.position.x;
          let dy = y + bubble.position.y;

          if (dx < 0 || dx > width) {
            dx = Math.random() * width;
          }
          if (dy < 0 || dy > height) {
            dy = Math.random() * height;
          }

          return { ...bubble, position: { x: dx, y: dy } };
        })
      );
    }, 16);

    return () => clearInterval(intervalId);
  }, []);

  return (
    <View style={styles.container}>
      <View style={styles.background} />
      {bubbles.map((bubble, index) => (
        <View
          key={index}
          style={[
            styles.bubble,
            {
              backgroundColor: bubble.color,
              width: bubble.radius * 2,
              height: bubble.radius * 2,
              borderRadius: bubble.radius,
              left: bubble.position.x,
              top: bubble.position.y,
            },
          ]}
        />
      ))}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'white',
  },
  background: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(173, 216, 230, 0.3)', 
  },
  bubble: {
    position: 'absolute',
  },
});

export default App;
