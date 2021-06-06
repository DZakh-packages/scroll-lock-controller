import dts from 'rollup-plugin-dts'
import esbuild from 'rollup-plugin-esbuild'




const makeBundle = ({ input, output }) => {
  return [
    {
      input,
      plugins: [esbuild()],
      output: [
        {
          file: `${output}.js`,
          format: 'cjs',
          sourcemap: true,
        },
        {
          file: `${output}.mjs`,
          format: 'es',
          sourcemap: true,
        },
      ],
      external: id => !/^[./]/.test(id),
    },
    {
      input,
      plugins: [dts()],
      output: {
        file: `${output}.d.ts`,
        format: 'es',
      },
      external: id => !/^[./]/.test(id),
    }
  ]
}

export default [
  ...makeBundle({
    input: './src/Manager.gen.tsx',
    output: './dist/scrollok',
  }),
  ...makeBundle({
    input: './src/ReservedGapPlugin.gen.tsx',
    output: './dist/plugins/reserved-gap-plugin',
  })
]