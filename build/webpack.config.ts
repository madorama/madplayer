import * as webpack from "webpack"
import * as path from "path"

const rules: webpack.RuleSetRule[] = [
  {
    exclude: path.join(__dirname, "node_modules"),
    use: "ts-loader"
  }
]

const main_config: webpack.Configuration = {
  mode: "development",
  target: "electron-main",
  entry: {
    "dist/main": path.join(__dirname, "src", "main"),
    "dist/preload": path.join(__dirname, "src", "preload"),
    "dist/javascripts/renderer": path.join(__dirname, "src", "renderer")
  },
  output: {
    path: __dirname,
    filename: "[name].js",
  },
  node: {
    __dirname: false,
    __filename: false
  },

  module: {
    rules: rules
  },
  resolve: {
    extensions: [".js", ".ts"]
  },
  watch: true,
}

export default main_config
